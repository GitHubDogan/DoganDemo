public class CustomerProductInformationController {
 @AuraEnabled 
    public static ContactInformation getCustomerProducts(string caseId){
        list<Contact> listOfContact=[Select Id,Name,Home_Country__c,Product__c,Product__r.Name from Contact where Home_Country__c!=null and Product__c!=null and Id in (Select ContactId from Case where Id=:caseId)];               
        if(listOfContact.size()==1)
        {
            return new ContactInformation(listOfContact[0]);           
        }
        else
            return null;
        
    } 
}