@isTest
public class EmailSenderTest {
    @testSetup 
    static void setupTestData() {
        Map<String, Object> fields = new Map<String, Object>();
        fields.put('Email','test@test.com');
        fields.put('FirstName','Contact First Name');
        Contact con1 =  TestDataFactory.createContacts(1, fields).get(0); 
        insert con1;
    }
    static testMethod void testGetOwaIdByAdress(){
        String result=EmailSender.getOwaIdByAdress('testemail@test.com');
        system.assertEquals(null, result);
    }
    static testMethod void testGetEmailTemplateByApiName(){
        test.startTest();
        EmailTemplate em=EmailSender.getEmailTemplateByApiName('Survey_Email_Template');
        EmailTemplate em2=EmailSender.getEmailTemplateByApiName('Unknown_Template');
        test.stopTest();
        system.assertEquals(em.DeveloperName, 'Survey_Email_Template');
        system.assertEquals(em2,null);
    }
    static testMethod void testcreateMailandsendMail(){
        
        test.startTest();
        EmailTemplate em=EmailSender.getEmailTemplateByApiName('Survey_Email_Template');
        string owaId= EmailSender.getOwaIdByAdress('testemail@test.com');
        Contact con1=[Select Id,Name from Contact where FirstName='Contact First Name'];
        list<Messaging.SingleEmailMessage> emailMessages=new list<Messaging.SingleEmailMessage>();
        emailMessages.add(EmailSender.createMail(null, con1.Id, em.Id, owaId, true));
        system.debug(EmailSender.sendMail(emailMessages));
        test.stopTest();
        EmailMessage emsg=[SELECT Id, EmailTemplateId FROM EmailMessage limit 1];
        system.assertEquals(em.Id, emsg.EmailTemplateId);
        
    }
}