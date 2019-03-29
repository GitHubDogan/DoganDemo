public abstract class Service{
    @AuraEnabled public string productId;
    @AuraEnabled public string serviceName;
    @AuraEnabled public string currencyISOCode;   
    
    public class ServiceFee extends Service{
        @AuraEnabled public decimal unitRate;
    }
    public class ServiceCost extends Service{
        @AuraEnabled public decimal unitPrice;
    }
}