/**
*   Domain Class for Time Entries Object 
*   Extending sObjectDomain Class and Invoke override methods based on the Trigger State
*
**/

public with sharing class TimeEntries extends SObjectDomain{

    public TimeEntries(List<Time_Entry__c> sObjectList){
        // Domain classes are initialised with lists to enforce bulkification throughout
        super(sObjectList);
    }    
        
    public override void onBeforeInsert(){
        UpdateTimerMinutes(null); 
        AssignTeamMember();       
    }  
    
    public override void onBeforeUpdate(Map<Id,SObject> existingRecords){
         UpdateTimerMinutes(existingRecords);      
    }      
    
    public void StopTimer(SObjectUnitOfWork uow){    
        for(Time_Entry__c timeEntry : (List<Time_Entry__c>) Records){
            timeEntry.Timer_Started__c = false; 
            uow.registerDirty(timeEntry);
        }
    }
    
    
    public void StartTimer(SObjectUnitOfWork uow){    
        for(Time_Entry__c timeEntry : (List<Time_Entry__c>) Records){
            timeEntry.Timer_Started__c = true; 
            uow.registerDirty(timeEntry);
        }
    }    
        
    private void UpdateTimerMinutes(Map<Id,SObject> existingRecords) {        
        for(Time_Entry__c record: (List<Time_Entry__c>) Records)
        {   
            //Assign Old Record from Existing records
            Time_Entry__c oldRecord = new Time_Entry__c();   
            if(existingRecords != null){              
                oldRecord = (Time_Entry__c)existingRecords.get(record.id);
            }
            // Find the Diffrence if the Timer is Stoped and Add the Difference in Minutes Field
            if(!record.Timer_Started__c  && existingRecords != null && record.Timer_Started__c != oldRecord.Timer_Started__c
                && record.Timer_Start_Date_Time__c != null ){
                Long startDateTime = record.Timer_Start_Date_Time__c.getTime();
                Long endDateTimeLong = system.now().getTime();
                Long milliseconds = endDateTimeLong  - startDateTime;
                Long seconds = milliseconds / 1000;
                Long minutes = seconds / 60;
                Long hours = minutes / 60;
                Long days = hours / 24;  
                record.Minutes__c = record.Minutes__c + minutes;              
                record.Timer_Start_Date_Time__c = null; // Assign the Start Date to null 
            }else if(record.Timer_Started__c  && (existingRecords == null || record.Timer_Started__c != oldRecord.Timer_Started__c) && record.Timer_Start_Date_Time__c == null){
                // If timer is Started Assign the Start Date to Current Date time
                record.Timer_Start_Date_Time__c = system.now();
            }   
        
        }                                                               
    }

    private void AssignTeamMember() {  
        
        set<Id> timeSheetIdSet = new set<Id>();
        for(Time_Entry__c record: (List<Time_Entry__c>) Records){   
            if(record.Time_Sheet__c != null){
                timeSheetIdSet.add(record.Time_Sheet__c);
            }
        }
        
        map<Id,Time_Sheet__c> timeSheetMap = new map<Id,Time_Sheet__c>(new TimeSheetSelector().selectById(timeSheetIdSet));
        set<Id> projectIdSet = new Set<Id>();        
        for(Time_Sheet__c tSheet : timeSheetMap.values()){
            projectIdSet.add(tSheet.project__c);
        }
        
        map<Id,Id> projectCurrentTeamMembermap = new map<Id,Id>();
        projectCurrentTeamMembermap  = new TeamMemberSelector().getCurrentTeamMembersByProjects(projectIdSet);
        for(Time_Entry__c record: (List<Time_Entry__c>) Records){   
            if(record.Time_Sheet__c != null){
                record.Team_Member__c = projectCurrentTeamMembermap.get(timeSheetMap.get(record.Time_Sheet__c).project__c);
            }
        }        
        
    }

    public class Constructor implements SObjectDomain.IConstructable{
        public SObjectDomain construct(List<SObject> sObjectList){
            return new TimeEntries(sObjectList);
        }
    }
       
}