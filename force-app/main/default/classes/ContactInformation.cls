public class ContactInformation { 
    @AuraEnabled
    public Customer customer;
    public ContactInformation(Contact c){
        list<PriceBookEntry> listOfPriceBookEntry=[Select Id, Name, CurrencyISOCode, Pricebook2.Name, Product2Id, Product2.Name, Product2.Family, UnitPrice, IsActive, UseStandardPrice, ProductCode, List_Price_Rate__c 
                                                   From PricebookEntry 
                                                   Where PriceBook2.Country__c=:c.Home_Country__c and Product2.Parent_Product__c = :c.Product__c and Product2.Family=:Constants.EXTRA_SERVICES];
        this.customer=new Customer();
        customer.contactName=c.Name;
        customer.country=c.Home_Country__c;
        customer.product=c.Product__r.Name;
        customer.services=new list<Service>();
        for(PriceBookEntry pbe:listOfPriceBookEntry)
        {
            if(pbe.List_Price_Rate__c!=null)
            {
                Service.ServiceFee serv=new Service.ServiceFee();
                serv.unitRate=pbe.List_Price_Rate__c;
                serv.productId=pbe.Product2Id;
                serv.serviceName=pbe.Product2.Name;
                serv.currencyISOCode=pbe.CurrencyIsoCode;
                customer.services.add(serv);
            }
            else
            {
                Service.ServiceCost serv=new Service.ServiceCost();
                serv.unitPrice=pbe.UnitPrice;
                serv.productId=pbe.Product2Id;
                serv.serviceName=pbe.Product2.Name;
                serv.currencyISOCode=pbe.CurrencyIsoCode;
                customer.services.add(serv);
            }
        }
    }
    
    
}