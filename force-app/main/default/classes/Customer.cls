public class Customer {
    @AuraEnabled public string contactName;
    @AuraEnabled public string country;
    @AuraEnabled public string product;
    @AuraEnabled public list<Service> services; 
}