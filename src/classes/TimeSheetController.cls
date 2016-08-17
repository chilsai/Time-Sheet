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
        // Todays Date
        Date currentDate = system.today();                
        // Get Week Start Date and End Date
        Date startDate = currentDate.toStartOfWeek();
        Date weekEndDate = startDate.addDays(6);                                        
        list<Time_Entry__c> timeEntries = new list<Time_Entry__c>();
        
        //Get Current week time Sheets of Different projects
        Map<id,Time_Sheet__c> tSheetMap = new Map<Id,Time_Sheet__c>([Select id,Weekend_Date__c from Time_Sheet__c where Weekend_Date__c =: weekEndDate]);
        
        // Get the Total time tracked for current week
        weekTimeReport weekRprt;
        timeEntries = [select id,Date__c,Minutes__c,Timer_Started__c,Time__c,Task__r.Name,Time_Sheet__r.Project__r.Name from Time_Entry__c  where Time_Sheet__c =: tSheetMap.keySet() AND Team_Member__r.Employee__c =: userInfo.getUserId() order by lastmodifieddate desc];
        
        string totalHours ;
        decimal totalMinutes = 0;
        // Caliculate total time in Minutes and Format to HH:MM
        for(Time_Entry__c te: timeEntries ){
            if(te.Minutes__c != null){
                totalMinutes = totalMinutes+te.Minutes__c;
            }        
        }
        
        decimal hours = math.floor(totalMinutes /60);
        string strHours = string.valueOf(hours);
        strHours = strHours.length() == 1? '0'+strHours:strHours;        
        integer minuts = math.MOD(integer.valueOf(totalMinutes ),60);
        string strminuts = string.valueOf(minuts);
        strminuts = strminuts.length() == 1? '0'+strminuts:strminuts ;        
        totalHours  = strHours +':' +strminuts;        
        weekRprt = new weekTimeReport(totalHours,startDate ,timeEntries);        
        
        return weekRprt ;
    } 


   /*    
    *  Description: Used to Stop the Timer 
    *  Referenced: Lightining Component (TimeSheetComponent)
    *  Parameters: Time Entry Record Td
    */            
    @AuraEnabled
    public static boolean stopTimer(string timerId){       
        Time_Entry__c  tEntry = new Time_Entry__c();
        tEntry.id = timerId;
        tEntry.Timer_Started__c = false;        
        update  tEntry;       
        return true;
    }

   /*    
    *  Description: Used to Start Timer 
    *  Referenced: Lightining Component (TimeSheetComponent)
    *  Parameters: Time Entry Record Td
    */              
    @AuraEnabled
    public static boolean startTimer(string timerId){        
        Time_Entry__c  tEntry = new Time_Entry__c();
        tEntry.id = timerId;
        tEntry.Timer_Started__c = true;        
        update  tEntry;       
        return true;
    }  
    
    
    
   /*    
    *  Description: Used to Create New Time Entry
    *  Referenced: Lightining Component (TimeSheetComponent)
    *  Parameters: Time Entry Object
    */          
    @AuraEnabled
    public static boolean createNewTimer(String TimeSheetId, String TaskId){ 
        try{       
            Time_Entry__c  tEntry = new Time_Entry__c();
            string prjId = [Select id,Project__c from Time_Sheet__c where Id =: TimeSheetId].Project__c ;
            Team_Member__c tMembr = [select id,Employee__c from Team_Member__c where Employee__c =: userInfo.getUserId() AND 
                                     Project__c =: prjId ];
            
            tEntry.Task__c = TaskId;
            tEntry.Time_Sheet__c = TimeSheetId;
            tEntry.Timer_Started__c = true;
            tEntry.Team_Member__c = tMembr.id;
            tEntry.Date__c = System.today();  
            insert   tEntry;
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
        list<Time_Sheet__c>   timeSheets = new list<Time_Sheet__c>(); 
        
        // Todays Date
        Date currentDate = system.today();                
        // Get Week Start Date and End Date
        Date startDate = currentDate.toStartOfWeek();
        Date weekEndDate = startDate.addDays(6);  
                
        timeSheets = [select id,Name,Project__r.Name from Time_Sheet__c where Weekend_Date__c =: weekEndDate];
        
        return timeSheets ;
    }       


   /*    
    *  Description: Used to Get list of Tasks for for the Project
    *  Referenced: Lightining Component (TimeSheetComponent)
    *  Parameters: ProjectId
    */          
    @AuraEnabled
    public static list<Task__c> getTaksList(String TimeSheetId){  
             
        list<Task__c> taskList = new list<Task__c>(); 
        system.debug(TimeSheetId);
        String ProjectId = [Select id,Project__c from Time_Sheet__c  where Id =: TimeSheetId].Project__c;
                
        if(ProjectId != null){
            taskList = [select id,Name from Task__c where Project__c =: ProjectId];
        }                
        return taskList;
    }                           
                                 
}