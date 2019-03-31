public abstract class Service{
    @AuraEnabled public string productId;
    @AuraEnabled public string serviceName;
    @AuraEnabled public string currencyISOCode;   
    
    public class ServiceFee extends Service{
        @AuraEnabled public decimal unitRate;
        public ServiceFee(PriceBookEntry pbe){
            this.unitRate=pbe.List_Price_Rate__c;
            this.productId=pbe.Product2Id;
            this.serviceName=pbe.Product2.Name;
            this.currencyISOCode=pbe.CurrencyIsoCode;
        }
    }
    public class ServiceCost extends Service{
        @AuraEnabled public decimal unitPrice;
        public ServiceCost(PriceBookEntry pbe){
            this.unitPrice=pbe.UnitPrice;
            this.productId=pbe.Product2Id;
            this.serviceName=pbe.Product2.Name;
            this.currencyISOCode=pbe.CurrencyIsoCode;
        }
    }
}