/**
 *  Selector Class to Construct the Dynamic Query for Task (Sobject)
 **/
public class TaskSelector extends SObjectSelector {

    public List<Schema.SObjectField> getSObjectFieldList(){    
        return new List<Schema.SObjectField> { 
                                                Task__c.Name,
                                                Task__c.Project__c
                                             };
    }

    public Schema.SObjectType getSObjectType(){
        return Task__c.sObjectType;
    }

    /**
     * Queries Task records by record Ids
     **/ 
    public List<Task__c> selectById(Set<ID> idSet){
        return (List<Task__c>) selectSObjectsById(idSet);
    }
    
    /**
     * Queries Time Sheet records and return map of Id and record based on Week End Date
     **/        
    public List<Task__c> getTaskByProject(set<Id> projectIdSet){        
        String query = String.format('select {0},{2} FROM {1} WHERE Project__c =: projectIdSet', 
                    new List<String>{
                        getFieldListString(),
                        getSObjectName(),
                        'Project__r.Name'
                    });      
        return (List<Task__c>) Database.query(query);  
    }
    
}