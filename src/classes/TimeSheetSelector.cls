/**
 *  Selector Class to Construct the Dynamic Query for Time Sheet (Sobject)
 **/
 
public class TimeSheetSelector extends SObjectSelector {

    public List<Schema.SObjectField> getSObjectFieldList(){    
        return new List<Schema.SObjectField> { 
                                                Time_Sheet__c.Weekend_Date__c,
                                                Time_Sheet__c.Project__c
                                             };
    }

    public Schema.SObjectType getSObjectType(){
        return Time_Sheet__c.sObjectType;
    }

    /**
     * Queries Time Entry records Ids
     **/ 
    public List<Time_Sheet__c> selectById(Set<ID> idSet){
        return (List<Time_Sheet__c>) selectSObjectsById(idSet);
    }
    
    /**
     * Queries Time Sheet records and return map of Id and record based on Week End Date
     **/        
    public Map<Id,Time_Sheet__c> getTimeSheetByWeekEndDate(date weekEndDate){        
        String query = String.format('select {0},{2} FROM {1} WHERE Weekend_Date__c =: weekEndDate', 
                    new List<String>{
                        getFieldListString(),
                        getSObjectName(),
                        'Project__r.Name'
                    });      
        return new map<Id,Time_Sheet__c>((List<Time_Sheet__c>) Database.query(query));  
    }
    
}