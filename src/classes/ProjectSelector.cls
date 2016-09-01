/**
*  Selector Class to Construct the Dynamic Query for Project (Sobject)
 **/
public class ProjectSelector extends SObjectSelector {

    public List<Schema.SObjectField> getSObjectFieldList(){
    
        return new List<Schema.SObjectField> { project__c.Start_Date__c,
                                               project__c.End_Date__c ,
                                               project__c.Name
                                               };
    }

    public Schema.SObjectType getSObjectType(){
        return project__c.sObjectType;
    }

    /**
     * Queries Project records by record Ids
     **/   
    public List<project__c> selectById(Set<ID> idSet){
        return (List<project__c>) selectSObjectsById(idSet);
    }
    
    /**
     * Queries Project records of not Expired
     **/        
    public Database.QueryLocator getNonExpiredProjectS(Date endDate){
        String query = String.format('select {0} FROM {1} WHERE End_Date__c >: endDate', 
                    new List<String>{
                        getFieldListString(),
                        getSObjectName()
                    });        
        return Database.getQueryLocator(query);  
    }
    
}