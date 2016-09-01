/*
*
*
*/

global with sharing class TaskService {       
    

    global static list<Task__c> getTotalTasksByTimeSheet(set<Id> timeSheetIds)
    {
          set<Id> ProjectIds = new set<Id>();
          for(Time_Sheet__c tSheet: new TimeSheetSelector().selectById(timeSheetIds)){
              ProjectIds.add(tSheet.Project__c);
          }          
          return new TaskSelector().getTaskByProject(ProjectIds);                 
    }
            
                
    // SObject's used by the logic in this service, listed in dependency order
    private static List<Schema.SObjectType> SERVICE_SOBJECTS = 
        new Schema.SObjectType[] { 
            Time_Sheet__c.SObjectType
            };  
}