/*
*  Service class encapsulate business logic for Time Entry Sobject
*
*/

global with sharing class TimeEntryService {           
    
    global static void StopTimer(set<Id> timeEntryIdSet )
    {
    
        // Create unit of work to capture work and commit it under one transaction
        SObjectUnitOfWork uow = new SObjectUnitOfWork(SERVICE_SOBJECTS);        
        
        TimeEntries timeEntries = new TimeEntries(
                        new TimeEntrySelector().selectById(timeEntryIdSet)); 
        timeEntries.StopTimer(uow);                
        // Commit any timeEntries updates
        uow.commitWork();                                   
    }   
    
    global static void StartTimer(set<Id> timeEntryIdSet )
    {
    
        // Create unit of work to capture work and commit it under one transaction
        SObjectUnitOfWork uow = new SObjectUnitOfWork(SERVICE_SOBJECTS);        
        
        TimeEntries timeEntries = new TimeEntries(
                        new TimeEntrySelector().selectById(timeEntryIdSet)); 
        timeEntries.StartTimer(uow);                
        // Commit any timeEntries updates
        uow.commitWork();                                   
    }        
     
    
    global static void CreateNewTimer(map<Id,Id> timeSheetTaskId)
    {       
        // Create unit of work to capture work and commit it under one transaction
        SObjectUnitOfWork uow = new SObjectUnitOfWork(SERVICE_SOBJECTS);        
        for(Id taskId: timeSheetTaskId.keyset())      
        {
            Time_Entry__c  tEntry = new Time_Entry__c();

            tEntry.Task__c = taskId;
            tEntry.Time_Sheet__c = timeSheetTaskId.get(taskId);
            tEntry.Timer_Started__c = true;
            tEntry.Date__c = System.today();              
            uow.registerNew(tEntry);   
        }        
        // Commit any Opportunity updates
        uow.commitWork();                                        
    }     
    
    global static list<Time_Entry__c> getTotalTimeEntriesForEachWeek(date weekEndDate)
    {
          list<Time_Entry__c> timeEntries =  new TimeEntrySelector().getTimeEntriesByTimeSheetAndCurrentUser(
                                                new TimeSheetSelector().getTimeSheetByWeekEndDate(weekEndDate).keyset(),
                                                new set<Id>{userInfo.getUserId()});
                                                
          return timeEntries;                 
    }


    global static decimal getTotalTimeOfWeek(list<Time_Entry__c> timeEntries )
    {
          decimal totalMinutes = 0;
          for(Time_Entry__c te: timeEntries ){
            if(te.Minutes__c != null){
                totalMinutes = totalMinutes+te.Minutes__c;
            }            
          }                                                
          return totalMinutes ;                 
    }    

    
    /*
    *  Format the Total minuts to HH : MM format
    */
    global static string FormatTimeToHHMM(decimal totalMinutes) {
        string strHours = string.valueOf(math.floor(totalMinutes /60));
        strHours = strHours.length() == 1? '0'+strHours:strHours;             
        string strminuts = string.valueOf(math.MOD(integer.valueOf(totalMinutes ),60));
        strminuts = strminuts.length() == 1? '0'+strminuts:strminuts ;                                
        return strHours +':' +strminuts;        
    }
                
    // SObject's used by the logic in this service, listed in dependency order
    private static List<Schema.SObjectType> SERVICE_SOBJECTS = 
        new Schema.SObjectType[] { 
            Time_Entry__c.SObjectType };  
}