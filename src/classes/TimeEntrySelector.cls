/**
 *  Selector Class to Construct the Dynamic Query for Time Entry(Sobject)
 **/
public class TimeEntrySelector extends SObjectSelector {

    public List<Schema.SObjectField> getSObjectFieldList(){
    
        return new List<Schema.SObjectField> { Time_Entry__c.Date__c,
                                               Time_Entry__c.Minutes__c,
                                               Time_Entry__c.Timer_Started__c,
                                               Time_Entry__c.Time__c,
                                               Time_Entry__c.projts__Task__c
                                               };
    }

    public Schema.SObjectType getSObjectType(){
        return Time_Entry__c.sObjectType;
    }

    /**
     * Queries Time Entry records Ids
     **/ 
    public List<Time_Entry__c> selectById(Set<ID> idSet){
        return (List<Time_Entry__c>) selectSObjectsById(idSet);
    }
    
    /**
     * Queries Time Entry records of diffrent Time Sheets
     **/        
    public list<Time_Entry__c> getTimeEntriesByTimeSheetAndCurrentUser(Set<Id> tSheetMapIds,Set<Id> UserIds){
        list<Time_Entry__c> timeEntryList = new list<Time_Entry__c>();
        String query = String.format('select {0},{2} FROM {1} WHERE Time_Sheet__c = :tSheetMapIds AND Team_Member__r.Employee__c =: UserIds order by lastmodifieddate desc', 
                    new List<String>{
                        getFieldListString(),
                        getSObjectName(),
                        'Task__r.Name,Time_Sheet__r.Project__r.Name'
                    });         
        return (List<Time_Entry__c>) Database.query(query);  
    }
    
}