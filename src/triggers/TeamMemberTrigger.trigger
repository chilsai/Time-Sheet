trigger TeamMemberTrigger on Team_Member__c (after Insert, after delete) {
    
    if(Trigger.isAfter && (Trigger.IsInsert || Trigger.IsDelete)){
        list<Team_Member__c> teamMemberList = new list<Team_Member__c>();        
        // If Delete Operation take list from Trigger.Old else take trigger.New
        teamMemberList = Trigger.IsInsert ? Trigger.New: Trigger.Old;       
        // Invoke Trigger Handler to Process the Team Member sharing
        TeamMemberTriggerHandler.ReCaliculateTeamMembers(teamMemberList,Trigger.IsInsert);    
    }
}