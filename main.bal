import ballerina/log;
import ballerinax/trigger.shopify;

configurable string shopifyApiSecretKey = ?;

shopify:ListenerConfig shopifyListenerConfig = {
    apiSecretKey: shopifyApiSecretKey
};

listener shopify:Listener shopifyListener = new(shopifyListenerConfig);

service shopify:OrdersService on shopifyListener {
    remote function onOrdersCreate(shopify:OrderEvent event) returns error? {
        string odrerNumber = event?.name.toString();
        string currency = event?.presentment_currency.toString();
        string totalPrice = event?.total_price.toString();
        string message = "Order No: " + odrerNumber + " Total Price: " + currency + totalPrice;
        log:printInfo(message);
    }
    remote function onOrdersCancelled(shopify:OrderEvent event) returns error? {
        // Write your logic here
    }
    remote function onOrdersFulfilled(shopify:OrderEvent event) returns error? {
        // Write your logic here
    }
    remote function onOrdersPaid(shopify:OrderEvent event) returns error? {
        // Write your logic here
    }
    remote function onOrdersPartiallyFulfilled(shopify:OrderEvent event) returns error? {
        // Write your logic here
    }
    remote function onOrdersUpdated(shopify:OrderEvent event) returns error? {
        // Write your logic here
    }
}
