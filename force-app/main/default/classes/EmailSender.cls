public without sharing class EmailSender {
    public static Id getOwaIdByAdress(String address){
        Map<String, Id> owaMap = new Map<String, Id>();
        
        for(OrgWideEmailAddress owa:[select id, address from OrgWideEmailAddress]){
            owaMap.put(owa.address, owa.id);
        }
        
        return owaMap.get(address);
    }
    public static EmailTemplate getEmailTemplateByApiName(string templateName){
        list<EmailTemplate> listOfEmailTemplate=[Select Id,DeveloperName from EmailTemplate where DeveloperName=:templateName];
        if(listOfEmailTemplate.size()==1)
            return listOfEmailTemplate[0];
        else
            return null;
    }
    public static Messaging.SingleEmailMessage createMail(Id whatId, Id targetObjectId, Id templateId, Id owaId, Boolean createtask){
		Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
		mail.setWhatId(whatId);
		mail.setTemplateID(templateId);
		mail.setTargetObjectId(targetObjectId); 
		mail.setSaveAsActivity(createtask);
		mail.setOrgWideEmailAddressId(owaId);
		return mail;
	}
    public static Messaging.SendEmailResult[] sendMail(List<Messaging.SingleEmailMessage> emailMessages){
        //If we hit daily limit of single email, this will throw "The daily limit for the org would be exceeded by this request error. So no email will be sent."
	    Messaging.reserveSingleEmailCapacity(emailMessages.size());			   
		Messaging.SendEmailResult[] result = Messaging.sendEmail(emailMessages,false);
        return result;
	}
}