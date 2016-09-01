/**************************************************************************************

Description : 1. Controller for TimeSheetComponent (Lightining Component)
              2. Used to Create Time Entry, Start Timer and Stop Timer.
              3. Used to Display Overall Tasks and Time for Current Week.

**************************************************************************************/

public with sharing class TimeSheetController {
        
    /*    
     *  Description: Get the Total Time Tracked for Current Week for Different Projects 
     *  Referenced: Lightining Component (TimeSheetComponent)
    */    
    @AuraEnabled
    public static weekTimeReport getTimeEntries() {               
    
        Date weekEndDate = system.today().toStartOfWeek().addDays(6);                                                                
        // Get total time Entries for week
        list<Time_Entry__c> timeEntries = TimeEntryService.getTotalTimeEntriesForEachWeek(weekEndDate);
        // Get total time for week  
        string totalHours = TimeEntryService.FormatTimeToHHMM(TimeEntryService.getTotalTimeOfWeek(timeEntries));   
                        
        weekTimeReport  weekRprt = new weekTimeReport(totalHours,system.today().toStartOfWeek(),timeEntries);                
        return weekRprt ;
    
    } 


   /*    
    *  Description: Used to Stop the Timer 
    *  Referenced: Lightining Component (TimeSheetComponent)
    *  Parameters: Time Entry Record Td
    */            
    @AuraEnabled
    public static boolean stopTimer(string timerId){       
        try{
            TimeEntryService.StopTimer(new set<id>{timerId});
            return true;
        }catch(Exception e){
             return false;   
        }        
    }

   /*    
    *  Description: Used to Start Timer 
    *  Referenced: Lightining Component (TimeSheetComponent)
    *  Parameters: Time Entry Record Td
    */              
    @AuraEnabled
    public static boolean startTimer(string timerId){        
        try{
            TimeEntryService.StartTimer(new set<id>{timerId});
            return true;
        }catch(Exception e){
             return false;   
        }  
    }  
            
   /*    
    *  Description: Used to Create New Time Entry
    *  Referenced: Lightining Component (TimeSheetComponent)
    *  Parameters: Time Entry Object
    */          
    @AuraEnabled
    public static boolean createNewTimer(String TimeSheetId, String TaskId){ 
        try{       
            map<Id,Id> taskTimeSheetMap = new map<Id,Id>();
            taskTimeSheetMap.put(TaskId,TimeSheetId);     
            // Invoke Service class to create new Time Entry                                
            TimeEntryService.CreateNewTimer(taskTimeSheetMap);
            return true;
        }catch(exception e){
            return false;
        }
    }     
    
   /*    
    *  Description: Used to Get list of Project for Current Week Time Sheet
    *  Referenced: Lightining Component (TimeSheetComponent)
    *  Parameters: No
    */          
    @AuraEnabled
    public static list<Time_Sheet__c> getProjectList(){                        
        return TimeSheetService.getTotalTimeSheetForEachWeek(system.today().toStartOfWeek().addDays(6));
    }       

    /*    
    *  Description: Used to Get list of Tasks for for the Project
    *  Referenced: Lightining Component (TimeSheetComponent)
    *  Parameters: ProjectId
    */          
    @AuraEnabled
    public static list<Task__c> getTaksList(String TimeSheetId){                                             
        return TaskService.getTotalTasksByTimeSheet(new set<Id>{TimeSheetId});
    }                           
                                 
}