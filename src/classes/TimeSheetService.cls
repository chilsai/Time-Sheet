/*
*
*
*/

global with sharing class TimeSheetService {       
    

    global static list<Time_Sheet__c> getTotalTimeSheetForEachWeek(date weekEndDate)
    {
          return new TimeSheetSelector().getTimeSheetByWeekEndDate(weekEndDate).values();                 
    }
    
    
    global static void createTimeSheetForProject(set<Id> projectIds)
    {
        // Create unit of work to capture work and commit it under one transaction
        SObjectUnitOfWork uow = new SObjectUnitOfWork(SERVICE_SOBJECTS);    
        for(Id projectId: projectIds){
            Time_Sheet__c tSheet = new Time_Sheet__c();
            tSheet.Project__c = projectId;
            tSheet.Weekend_Date__c = system.today().addDays(6);   
            uow.registerNew(tSheet);         
        } 
        uow.commitWork();                     
    }    
            
                
    // SObject's used by the logic in this service, listed in dependency order
    private static List<Schema.SObjectType> SERVICE_SOBJECTS = 
        new Schema.SObjectType[] { 
            Time_Sheet__c.SObjectType
            };  
}