global class SendSurveyBatch implements DataBase.Batchable<sObject>{	
    
    global SurveyEmailSetting__mdt eMailSetting;
    global string owaId;
    global boolean saveAsActivity;
    global string templateId;
    global string query;
    global SendSurveyBatch(String name){
        //I prefer to store email setting on Custom Metadata Type so that for small changes we dont need to change apex class.
        //Example: We may want to use different email template, we may want to change the query 
        list<SurveyEmailSetting__mdt> listOfSurveyEmailSetting=new list<SurveyEmailSetting__mdt>([SELECT Id, Label, SurveyTemplateAPIName__c, Query__c, SaveAsActivity__c, SenderEmailAddress__c  FROM SurveyEmailSetting__mdt where Label=:name]);
        if(listOfSurveyEmailSetting.size()==1){
            eMailSetting=listOfSurveyEmailSetting[0];
            owaId=EmailSender.getOwaIdByAdress(eMailSetting.SenderEmailAddress__c);
            saveAsActivity=eMailSetting.SaveAsActivity__c;
            EmailTemplate et=EmailSender.getEmailTemplateByApiName(eMailSetting.SurveyTemplateAPIName__c);
            query=eMailSetting.Query__c;
            templateId=et.Id;
        }
        
    }
    global Database.QueryLocator start(Database.BatchableContext context){
        
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope){
        list<Messaging.SingleEmailMessage> listOfSingleEmailMessage=new list<Messaging.SingleEmailMessage>();
        list<Contact> toUpdate=new list<Contact>();
        for(Contact con:((List<Contact>)scope)){
            listOfSingleEmailMessage.add(EmailSender.createMail(null, con.Id, templateId, owaId, saveAsActivity));
        } 
        try {
            list<Messaging.SendEmailResult> results=EmailSender.sendMail(listOfSingleEmailMessage);                 
            for(Integer i=0;i<results.size();i++)
            {
                if(results.get(i).isSuccess())
                {
                    //We only want to update contacts that emails are successfully sent.                    
                    Messaging.SingleEmailMessage singleEmail=listOfSingleEmailMessage.get(i);
                    toUpdate.add(new Contact(Id=singleEmail.getTargetObjectId(),Survey_Date__c=null));
                }
            }
            update toUpdate;
            
        }
        catch(Exception e) 
        {
            //Here we can send an email to administrator but I prefer not to send this time.
            //If daily email limit is reached, error will be caught here.
        }
    }
    
    
    global void finish(Database.BatchableContext context){}
    
}