/**
 *  Selector Class to Construct the Dynamic Query for Team Member(Sobject)
 **/
public class TeamMemberSelector extends SObjectSelector {

    public List<Schema.SObjectField> getSObjectFieldList(){    
        return new List<Schema.SObjectField> { 
                                                Team_Member__c.Project__c,
                                                Team_Member__c.Employee__c
                                             };
    }

    public Schema.SObjectType getSObjectType(){
        return Team_Member__c.sObjectType;
    }
    
    /**
     * Queries Team Member records and return map of Id
     **/ 
    public List<Team_Member__c> selectById(Set<ID> idSet){
        return (List<Team_Member__c>) selectSObjectsById(idSet);
    }
    
    /**
     * Queries Time Sheet records and return map of Id and record based on Week End Date
     **/        
    public Map<Id,Id> getCurrentTeamMembersByProjects(set<Id> projectIdSet){  
        Id CurrentUserId =  userInfo.getUserId();      
        String query = String.format('select {0},{2} FROM {1} WHERE Employee__c =: CurrentUserId  AND Project__c =: projectIdSet', 
                    new List<String>{
                        getFieldListString(),
                        getSObjectName(),
                        'Project__r.Name'
                    }); 
        map<Id,Id> projectTeamMebrMap = new map<Id,Id>();
        for(Team_Member__c teamMembr: (List<Team_Member__c>) Database.query(query)){
            projectTeamMebrMap.put(teamMembr.project__c,teamMembr.id);
        }     
        return projectTeamMebrMap;  
    }
    
}