import ballerina/http;
import ballerina/log;

type ShopifyCustomer record {
    string email;
    string first_name?;
    string last_name?;
    Address default_address?;
};

type Address record {
    int id;
    string address1;
    string address2;
    string city;
    string country;
    string zip;
};

type ShopifyOrder record {
};

service /sap_bridge on new http:Listener(9090) {
    resource function post customers(@http:Payload ShopifyCustomer shopifyCustomer) {
        log:printInfo("Received customer: " + shopifyCustomer.toJsonString());
    }

    resource function post orders(@http:Payload ShopifyOrder shopifyOrder) {
        log:printInfo("Received order: " + shopifyOrder.toJsonString());
    }
}
