/**
*   Domain Class for Team Member Object 
*   Extending sObjectDomain Class and Invoke override methods based on the Trigger State
*
**/

public with sharing class TeamMembers extends SObjectDomain{


    public TeamMembers(List<Team_Member__c> sObjectList){
        // Domain classes are initialised with lists to enforce bulkification throughout
        super(sObjectList);
    }    
    
    
    public override void onAfterInsert(){
        addTeamMembrsToProjShare();
    } 
    
    public override void onAfterUpdate(map<Id,sObject> existingRecords){
        addTeamMembrsToProjShare();
        map<string,string>  TeamMembrToProjMap = new Map<string,string>();
        for(Team_Member__c record: (List<Team_Member__c>) Records){            
            Team_Member__c  oldTeamMember = (Team_Member__c)existingRecords.get(record.id);
            if(oldTeamMember.Employee__c != record.Employee__c){
                TeamMembrToProjMap.put(oldTeamMember.Employee__c,oldTeamMember.Project__c);
            }
        }
        deleteTeamMembrsFromProjShare(TeamMembrToProjMap); 
    }             
    
    public override void onAfterDelete(){
        map<string,string>  TeamMembrToProjMap = new Map<string,string>();
        for(Team_Member__c record: (List<Team_Member__c>) Records){
            TeamMembrToProjMap.put(record.Employee__c,record.Project__c);
        }
        deleteTeamMembrsFromProjShare(TeamMembrToProjMap); 
    } 
        
    private void addTeamMembrsToProjShare() {     
        try{        
            SObjectUnitOfWork uow = new SObjectUnitOfWork(new Schema.SObjectType[] { Project__Share.SObjectType });         
            for(Team_Member__c record : (List<Team_Member__c>) Records){
                    Project__Share pShare = new Project__Share();
                    pShare.userorGroupId = record.Employee__c;
                    pShare.AccessLevel = 'Edit';
                    pShare.ParentId = record.Project__c;  
                    uow.registerNew(pShare);    
            } 
            uow.commitWork();   
        }catch(exception e){
            // To DO
        }
    }
    
    
    private void deleteTeamMembrsFromProjShare(map<string,string>  TeamMembrToProjMap) {   
        try{          
            SObjectUnitOfWork uow = new SObjectUnitOfWork(new Schema.SObjectType[] { Project__Share.SObjectType });                 
            list<Project__Share> proShareDeleteList = new list<Project__Share>();
            list<Project__Share> DeleProjShareList = new list<Project__Share>();        
            proShareDeleteList = [select id,UserOrGroupId,parentId,rowcause from Project__Share where userorgroupid =: TeamMembrToProjMap.keyset() and parentId =: TeamMembrToProjMap.values() ];
            
            for(Project__Share prShr: proShareDeleteList ){
                if(TeamMembrToProjMap.containskey(prShr.UserOrGroupId) && 
                    TeamMembrToProjMap.get(prShr.UserOrGroupId) == prShr.parentId && prShr.rowcause != 'Owner'){                
                    uow.registerDeleted(prShr);       
                }
            }        
            uow.commitWork();   
        }catch(exception e){
            // To DO
        }
    }    
    
    
    public class Constructor implements SObjectDomain.IConstructable{
        public SObjectDomain construct(List<SObject> sObjectList){
            return new TeamMembers(sObjectList);
        }
    }    
        
}