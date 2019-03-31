public class Customer {
    @AuraEnabled public string contactName;
    @AuraEnabled public string country;
    @AuraEnabled public string product;
    @AuraEnabled public list<Service> services; 
    public Customer(string contactName, string country, string product, list<PriceBookEntry> listOfPriceBookEntry)
    {
        this.contactName=contactName;
        this.country=country;
        this.product=product;
        this.services=new list<Service>();
        for(PriceBookEntry pbe:listOfPriceBookEntry)
        {
            if(pbe.List_Price_Rate__c!=null)
            {
                Service.ServiceFee serv=new Service.ServiceFee(pbe);                
                services.add(serv);
            }
            else
            {
                Service.ServiceCost serv=new Service.ServiceCost(pbe);           
                services.add(serv);
            }
        }
    }
    
}