import ballerina/http;
import ballerina/log;
import ballerinax/salesforce as sf;

configurable sf:ConnectionConfig salesforceConfig = ?;
sf:Client salesforce = check new (salesforceConfig);

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

service /salesforce_bridge on new http:Listener(9090) {
    resource function post customers(@http:Payload ShopifyCustomer shopifyCustomer) {
        log:printInfo("Received customer: " + shopifyCustomer.toJsonString());
    }
}
