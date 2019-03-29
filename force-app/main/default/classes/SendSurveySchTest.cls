@isTest
public class SendSurveySchTest {
    public static testMethod void testScheduleSurveySch(){
        String CRON_EXP = '0 0 0 15 3 ? *';
        Map<String, Object> fields = new Map<String, Object>();
        fields.put('FirstName','firstName');
        fields.put('Email','test@test.com');
        fields.put('Survey_Date__c',Date.today());        
        list<Contact> listOfContact=TestDataFactory.createContacts(1, fields); 
        insert listOfContact;  
        Test.startTest();        
        String jobId = System.schedule('ScheduleApexClassTest',  CRON_EXP, new SendSurveySch());
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
        System.assertEquals(CRON_EXP, ct.CronExpression);
        System.assertEquals(0, ct.TimesTriggered);        
        Test.stopTest();
        
    }
}