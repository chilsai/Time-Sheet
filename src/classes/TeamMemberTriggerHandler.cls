/****************************************************************************************

Description: Adding the Team members to Project Share object give them access to the Project,
             Time Sheet records.

Referenced in TeamMemberTrigger
****************************************************************************************/

public class TeamMemberTriggerHandler{


    public static void ReCaliculateTeamMembers(list<Team_Member__c> teamMembers, boolean isInsert){        
        list<Project__Share> proShareList = new list<Project__Share>();
        map<string,string>  TeamMembrToProjMap = new Map<string,string>();
        
        for(Team_Member__c temBr: teamMembers){
            if(isInsert){                
                Project__Share pShare = new Project__Share();
                pShare.userorGroupId = temBr.Employee__c;
                pShare.AccessLevel = 'Edit';
                pShare.ParentId = temBr.Project__c;
                proShareList.add(pShare);
            }else{
                TeamMembrToProjMap.put(temBr.Employee__c,temBr.Project__c);                
            }
        }
        
        if(isInsert && proShareList.size() > 0){ 
            insert proShareList;
                        
            // The false parameter allows for partial processing if multiple records passed 
            // into the operation.
            list<Database.SaveResult> sr = Database.insert(proShareList,false);
               
        }
        
        list<Project__Share> proShareDeleteList = new list<Project__Share>();
        list<Project__Share> DeleProjShareList = new list<Project__Share>();
        
        proShareDeleteList = [select id,UserOrGroupId,parentId from Project__Share where userorgroupid =: TeamMembrToProjMap.keyset() and parentId =: TeamMembrToProjMap.values() ];
        
        for(Project__Share prShr: proShareDeleteList ){
            if(TeamMembrToProjMap.containskey(prShr.UserOrGroupId) && 
                TeamMembrToProjMap.get(prShr.UserOrGroupId) == prShr.parentId){
                DeleProjShareList.add(prShr);        
            }
        }
        
        // Delete the Sharing after removing team member
        if(DeleProjShareList.size() > 0){
            delete DeleProjShareList;
        }
                    
    }

}