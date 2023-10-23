import ballerina/http;
import ballerina/log;

map<string> supplierMap = {"7336631533890": "17300096"};
map<string> organizationMap = {"US Steel Corp": "1710"};
map<string> groupMap = {"US Steel Corp": "001"};
map<string> plantMap = {"US Steel Corp": "1710"};
map<string> materialMap = {"8882299109698": "E001"};
map<string> taxJurisdictionMap = {"United States": "KY00000000"};

service /sap_bridge on new http:Listener(9090) {
    resource function post orders(@http:Payload ShopifyOrder shopifyOrder) {
        log:printInfo("Received order: " + shopifyOrder.toJsonString());
        SAPPurchaseOrder|error sapOrder = transformCustomerData(shopifyOrder);
        if sapOrder is error {
            log:printError("Error while transforming order: " + sapOrder.message());
            return;
        }
        log:printInfo("Transformed order: " + sapOrder.toJsonString());
    }
}

function transformCustomerData(ShopifyOrder shopifyOrder) returns SAPPurchaseOrder|error {
    string purchaseOrderType = "NB";
    string supplier = supplierMap.get(shopifyOrder.customer.id.toString());
    string organization = organizationMap.get(shopifyOrder.customer.default_address.company);
    string group = groupMap.get(shopifyOrder.customer.default_address.company);
    string companyCode = organizationMap.get(shopifyOrder.customer.default_address.company);

    // TODO: check the ability to use the same variable instead of getting the same thing again
    string plant = organizationMap.get(shopifyOrder.customer.default_address.company);
    string taxJurisdiction = taxJurisdictionMap.get(shopifyOrder.customer.default_address.country);
    string currency = shopifyOrder.currency;

    OrderItem[] orderItems = [];

    // TODO: use query instead
    // TODO: simplify the variable names
    foreach LineItem lineItem in shopifyOrder.line_items {
        int quantity = lineItem.quantity;
        string unit = "kg"; // TODO: use a constant
        string category = "U";
        string material = materialMap.get(lineItem.product_id.toString());
        float price = check float:fromString(lineItem.price);

        orderItems.push({
            Plant: plant,
            OrderQuantity: quantity,
            PurchaseOrderQuantityUnit: unit,
            AccountAssignmentCategory: category,
            Material: material,
            NetPriceAmount: price,
            DocumentCurrency: currency,
            TaxJurisdiction: taxJurisdiction
        });
    }
    return {
        PurchaseOrderType: purchaseOrderType,
        Supplier: supplier,
        PurchasingOrganization: organization,
        PurchasingGroup: group,
        CompanyCode: companyCode,
        _PurchaseOrderItem: orderItems
    };
}
