type ShopifyOrder record {
    string company;
    Customer customer;
    LineItem[] line_items;
};

type LineItem record {
    string price;
    int quantity;
    string presentment_currency;
    int product_id; // maps to Material
};

type Customer record {
    int id;
    DefaultAddress default_address;
};

type DefaultAddress record {
    string company; // maps to purchasing organization, purchasing group
    string country; // maps to TaxJurisdiction
};

type SAPPurchaseOrder record {
    string PurchaseOrderType; // HARDCODE
    string Supplier; // maps to customer
    string PurchasingOrganization; //
    string PurchasingGroup; //
    string CompanyCode; //
    OrderItem[] _PurchaseOrderItem; //
};

type OrderItem record {
    string Plant; // HARDCODE
    int OrderQuantity; //
    string PurchaseOrderQuantityUnit; // HARDCODE
    string AccountAssignmentCategory; // HARDCODE
    string Material; //
    float NetPriceAmount; //
    string DocumentCurrency; //
    string TaxJurisdiction; // Map according to the country
};
