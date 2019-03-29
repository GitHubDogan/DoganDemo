@isTest
public class TestDataFactory {
    //This class is used for creating test data
    public static List<Contact> createContacts(Integer recNum, Map<String, Object> fieldsValueByName){
        //Add required fields if not inputted
        if(!fieldsValueByName.containsKey('LastName'))fieldsValueByName.put('LastName', 'LastName');        
        
        return (List<Contact>)generatesObjects('Contact', recNum, fieldsValueByName);
    }
    public static List<Case> createCases(Integer recNum, Map<String, Object> fieldsValueByName){
        if(!fieldsValueByName.containsKey('Origin'))fieldsValueByName.put('Origin', 'Email');        
        return (List<Case>)generatesObjects('Case', recNum, fieldsValueByName);
    }
    public static List<sObject> generatesObjects(String sObjType, Integer recNum, Map<String, Object> fieldsValueByName){
        List<sObject> sObjList = new List<sObject>();
        Map<String,Schema.SObjectType> globalDescribeData = Schema.getGlobalDescribe(); 
        Schema.sObjectType sObjectType = globalDescribeData.get(sObjType);        
        for (Integer i = 1; i <= recNum; i++){
            sObject sObj = sObjectType.newSObject();
            for (String field : fieldsValueByName.keySet()){
                sObj.put(field, fieldsValueByName.get(field));
            }
            sObjList.add(sObj);
        }
        return sObjList;
    }
    public static void setupPricebook(){
        Product2 pBlack = new Product2(Name = 'Black', Family = 'Membership', ProductCode = 'BLACK', isActive=true);
        insert pBlack;   
        Product2 pMetal = new Product2(Name = 'Metal', Family = 'Membership', ProductCode = 'METAL', isActive=true);
        insert pMetal;  
        Product2 pStandard = new Product2(Name = 'Standard', Family = 'Membership', ProductCode = 'STANDARD', isActive=true);
        insert pStandard;
        list<Product2> toInsert=new list<Product2>();
        toInsert.add(new Product2(Name = 'ATM Fee', Family = 'Extra Services', ProductCode = 'ATM-FEE-STANDARD', Parent_Product__c=pStandard.Id,isActive=true));
        toInsert.add(new Product2(Name = 'ATM Fee', Family = 'Extra Services', ProductCode = 'ATM-FEE-BLACK', Parent_Product__c=pBlack.Id,isActive=true));
        toInsert.add(new Product2(Name = 'ATM Fee', Family = 'Extra Services', ProductCode = 'ATM-FEE-METAL', Parent_Product__c=pMetal.Id,isActive=true));
        toInsert.add(new Product2(Name = 'Card Replacement Cost', Family = 'Extra Services', ProductCode = 'CARD-REP-COST-METAL', Parent_Product__c=pMetal.Id,isActive=true));
        toInsert.add(new Product2(Name = 'Card Replacement Cost', Family = 'Extra Services', ProductCode = 'CARD-REP-COST-BLACK', Parent_Product__c=pBlack.Id,isActive=true));       
        toInsert.add(new Product2(Name = 'Card Replacement Cost', Family = 'Extra Services', ProductCode = 'CARD-REP-COST-STANDARD', Parent_Product__c=pStandard.Id,isActive=true));       
        toInsert.add(new Product2(Name = 'Cost Membership (Monthly)', Family = 'Extra Services', ProductCode = 'SUBS-STANDARD', Parent_Product__c=pStandard.Id,isActive=true));       
        toInsert.add(new Product2(Name = 'Cost Membership (Monthly)', Family = 'Extra Services', ProductCode = 'SUBS-METAL', Parent_Product__c=pMetal.Id,isActive=true));       
        toInsert.add(new Product2(Name = 'Cost Membership (Monthly)', Family = 'Extra Services', ProductCode = 'SUBS-BLACK', Parent_Product__c=pBlack.Id,isActive=true));       
        insert toInsert;
        // Get standard price book ID.
        // This is available irrespective of the state of SeeAllData.
        Id pricebookId = Test.getStandardPricebookId();
        Pricebook2 standardPB = new Pricebook2(isActive=true, Id=pricebookId);
        update standardPB;
        list<PriceBook2> toInsertPB=new list<PriceBook2>();
        toInsertPB.add(new PriceBook2(Name='UK', IsActive=true, Country__c='UK'));
        toInsertPB.add(new PriceBook2(Name='ES', IsActive=true, Country__c='ES'));
        toInsertPB.add(new PriceBook2(Name='DE', IsActive=true, Country__c='DE'));
        toInsertPB.add(new PriceBook2(Name='IT', IsActive=true, Country__c='IT'));
        toInsertPB.add(new PriceBook2(Name='FR', IsActive=true, Country__c='FR'));
        insert toInsertPB;
        map<string,Id> mapNamePriceBookId=new map<String ,Id>();
        for(PriceBook2 pb:toInsertPB)
        {
            mapNamePriceBookId.put(pb.Name,pb.Id);
        }
        // 1. Insert a price book entry for the standard price book.
        // Standard price book entries require the standard price book ID we got earlier.
        list<PriceBookEntry> toInsertPriceBookEntry=new list<PriceBookEntry>();
        for(Product2 p:toInsert)
        {
            toInsertPriceBookEntry.add(new PriceBookEntry(PriceBook2Id=standardPB.Id,Product2Id=p.Id,UnitPrice=0.0,CurrencyISOCode='EUR'));
            toInsertPriceBookEntry.add(new PriceBookEntry(PriceBook2Id=standardPB.Id,Product2Id=p.Id,UnitPrice=0.0,CurrencyISOCode='GBP'));
            //UK PriceBook
            if(p.Name=='ATM Fee')
                toInsertPriceBookEntry.add(new PriceBookEntry(PriceBook2Id=mapNamePriceBookId.get('UK'),Product2Id=p.Id,UnitPrice=0.0,CurrencyISOCode='GBP',List_Price_Rate__c=1.7));
            else
                toInsertPriceBookEntry.add(new PriceBookEntry(PriceBook2Id=mapNamePriceBookId.get('UK'),Product2Id=p.Id,UnitPrice=1.0,CurrencyISOCode='GBP'));           
            //ES PriceBook
            if(p.Name=='ATM Fee')
                toInsertPriceBookEntry.add(new PriceBookEntry(PriceBook2Id=mapNamePriceBookId.get('ES'),Product2Id=p.Id,UnitPrice=0.0,CurrencyISOCode='EUR',List_Price_Rate__c=1.7));
            else
                toInsertPriceBookEntry.add(new PriceBookEntry(PriceBook2Id=mapNamePriceBookId.get('ES'),Product2Id=p.Id,UnitPrice=2.0,CurrencyISOCode='EUR'));
            //DE PriceBook
            if(p.Name=='ATM Fee')
                toInsertPriceBookEntry.add(new PriceBookEntry(PriceBook2Id=mapNamePriceBookId.get('DE'),Product2Id=p.Id,UnitPrice=0.0,CurrencyISOCode='EUR',List_Price_Rate__c=1.7));
            else
                toInsertPriceBookEntry.add(new PriceBookEntry(PriceBook2Id=mapNamePriceBookId.get('DE'),Product2Id=p.Id,UnitPrice=3.0,CurrencyISOCode='EUR'));
            //IT PriceBook
            if(p.Name=='ATM Fee')
                toInsertPriceBookEntry.add(new PriceBookEntry(PriceBook2Id=mapNamePriceBookId.get('IT'),Product2Id=p.Id,UnitPrice=0.0,CurrencyISOCode='EUR',List_Price_Rate__c=1.7));
            else
                toInsertPriceBookEntry.add(new PriceBookEntry(PriceBook2Id=mapNamePriceBookId.get('IT'),Product2Id=p.Id,UnitPrice=4.0,CurrencyISOCode='EUR'));
            //DE PriceBook
            if(p.Name=='ATM Fee')
                toInsertPriceBookEntry.add(new PriceBookEntry(PriceBook2Id=mapNamePriceBookId.get('FR'),Product2Id=p.Id,UnitPrice=0.0,CurrencyISOCode='EUR',List_Price_Rate__c=1.7));
            else
                toInsertPriceBookEntry.add(new PriceBookEntry(PriceBook2Id=mapNamePriceBookId.get('FR'),Product2Id=p.Id,UnitPrice=5.0,CurrencyISOCode='EUR'));
        }
           insert toInsertPriceBookEntry;
        
    }
}