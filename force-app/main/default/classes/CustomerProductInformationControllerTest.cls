@isTest
public class CustomerProductInformationControllerTest {
    @testSetup 
    static void setupTestData() {
        TestDataFactory.setupPricebook();        
        
    }
    static testMethod void negativeTestCase(){
        map<String, Object> fields = new Map<String, Object>();
        test.startTest();
        Case c=TestDataFactory.createCases(1, fields).get(0);
        insert c;
        ContactInformation ci=CustomerProductInformationController.getCustomerProducts(c.Id);
        test.stopTest();
        system.assertEquals(null, ci);
    }
    static testMethod void testGermanContactandProduct(){
        test.startTest();
        Product2 p=[Select Id from Product2 where Name='Metal'];
        Map<String, Object> fields = new Map<String, Object>();
        fields.put('Email','test@test.com');
        fields.put('FirstName','German Contact');
        fields.put('Home_Country__c','DE');
        fields.put('Product__c',p.Id);
        Contact con =  TestDataFactory.createContacts(1, fields).get(0); 
        insert con;
        fields = new Map<String, Object>();
        fields.put('ContactId', con.Id);
        Case c=TestDataFactory.createCases(1, fields).get(0);
        insert c;
        ContactInformation ci=CustomerProductInformationController.getCustomerProducts(c.Id);
        test.stopTest();
        system.assertEquals(ci.Customer.product,'Metal');
        system.assertEquals(ci.Customer.country,'DE');
        list<Service> services=ci.Customer.services;
        for(Service serv:services)
        {
             
            if(serv instanceOf Service.ServiceFee)
            {
                Service.ServiceFee fee=(Service.ServiceFee)serv;
                system.assertEquals(fee.unitRate , 1.7);
                system.assertEquals(fee.currencyISOCode, 'EUR');
            }
            if(serv instanceOf Service.ServiceCost)
            {
                Service.ServiceCost cost=(Service.ServiceCost)serv;
                system.assertEquals(cost.unitPrice, 3);
                system.assertEquals(cost.currencyISOCode, 'EUR');
            }
        }
       
    }
    static testMethod void testUKContactandProduct(){
        test.startTest();
        Product2 p=[Select Id from Product2 where Name='Metal'];
        Map<String, Object> fields = new Map<String, Object>();
        fields.put('Email','test@test.com');
        fields.put('FirstName','UK Contact');
        fields.put('Home_Country__c','UK');
        fields.put('Product__c',p.Id);
        Contact con =  TestDataFactory.createContacts(1, fields).get(0); 
        insert con;
        fields = new Map<String, Object>();
        fields.put('ContactId', con.Id);
        Case c=TestDataFactory.createCases(1, fields).get(0);
        insert c;
        ContactInformation ci=CustomerProductInformationController.getCustomerProducts(c.Id);
        test.stopTest();
        system.assertEquals(ci.Customer.product,'Metal');
        system.assertEquals(ci.Customer.country,'UK');
        list<Service> services=ci.Customer.services;
        for(Service serv:services)
        {
             
            if(serv instanceOf Service.ServiceFee)
            {
                Service.ServiceFee fee=(Service.ServiceFee)serv;
                system.assertEquals(fee.unitRate, 1.7);
                system.assertEquals(fee.currencyISOCode, 'GBP');
            }
            if(serv instanceOf Service.ServiceCost)
            {
                Service.ServiceCost cost=(Service.ServiceCost)serv;
                system.assertEquals(cost.unitPrice, 1);
                system.assertEquals(cost.currencyISOCode, 'GBP');
            }
        }
       
    }
}