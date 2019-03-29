@isTest
public class SendSurveyBatchTest {
   
    static testMethod void successJob(){
        Map<String, Object> fields = new Map<String, Object>();
        fields.put('Email','test@test.com');
        fields.put('FirstName','Contact First Name');
        fields.put('Survey_Date__c',Date.today());
        Contact con1 =  TestDataFactory.createContacts(1, fields).get(0); 
        insert con1;
        test.startTest();
        SendSurveyBatch objClass = new SendSurveyBatch('Survey');
        Database.executeBatch (objClass);
        test.stopTest();
        Con1=[Select Id,Survey_Date__c from Contact where FirstName='Contact First Name'];
        system.assertEquals(con1.Survey_Date__c, null);
    }
    static testMethod void multipleRecords(){
        Map<String, Object> fields = new Map<String, Object>();
        fields.put('Email','testtest@test.com');
        fields.put('FirstName','Contact First Name');
        fields.put('Survey_Date__c',Date.today());
        list<Contact> listOfContact =  TestDataFactory.createContacts(10, fields); 
        insert listOfContact;
        test.startTest();
        SendSurveyBatch objClass = new SendSurveyBatch('Survey');
        Database.executeBatch (objClass);
        test.stopTest();
        list<Contact> result=[Select Id,Survey_Date__c from Contact where Survey_Date__c=null];
        system.assertEquals(10, result.size());
    }
    static testMethod void surveyDateInFuture(){
         Map<String, Object> fields = new Map<String, Object>();
        fields.put('Email','test@test.com');
        fields.put('FirstName','Contact First Name');
        fields.put('Survey_Date__c',Date.today()+1);
        Contact con1 =  TestDataFactory.createContacts(1, fields).get(0); 
        insert con1;
        test.startTest();
        SendSurveyBatch objClass = new SendSurveyBatch('Survey');
        Database.executeBatch (objClass);
        test.stopTest();
        Con1=[Select Id,Survey_Date__c from Contact where FirstName='Contact First Name'];
        system.assertEquals(con1.Survey_Date__c, Date.today()+1);
    }
    
}