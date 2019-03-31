public class ContactInformation { 
    @AuraEnabled
    public Customer customer;
    public ContactInformation(Contact c){
        list<PriceBookEntry> listOfPriceBookEntry=[Select Id, Name, CurrencyISOCode, Pricebook2.Name, Product2Id, Product2.Name, Product2.Family, UnitPrice, IsActive, UseStandardPrice, ProductCode, List_Price_Rate__c 
                                                   From PricebookEntry 
                                                   Where PriceBook2.Country__c=:c.Home_Country__c and Product2.Parent_Product__c = :c.Product__c and Product2.Family=:Constants.EXTRA_SERVICES];
        this.customer=new Customer(c.Name,c.Home_Country__c,c.Product__r.Name,listOfPriceBookEntry);
        
    }
    
    
}