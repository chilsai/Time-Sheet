/************************************************************************************

Author: Sai Sagar
Description: Trigger Used to Update the Time in Minutes based on Start and Star Time
Referenced: TimeEntryTrigger (Before Insert and Before Update)
*************************************************************************************/

public class TimeEntryTriggerHandler{
                                                            
   /*  Description: Update the Time in Minutes based on Start and Star Time
    *  Parameters: Trigger.New list of time Entries and Old Entries of it is Update Operation
    */
    public static void UpdateTimerMinutes(list<Time_Entry__c> newTimerlist,map<id,Time_Entry__c> oldTime){ 

        for(Time_Entry__c timer: newTimerlist){            
            // Find the Diffrence if the Timer is Stoped and Add the Difference in Minutes Field
            if(!timer.Timer_Started__c  && oldTime != null && timer.Timer_Started__c != oldTime.get(timer.id).Timer_Started__c
                && timer.Timer_Start_Date_Time__c != null ){
                Long startDateTime = timer.Timer_Start_Date_Time__c.getTime();
                Long endDateTimeLong = system.now().getTime();
                Long milliseconds = endDateTimeLong  - startDateTime;
                Long seconds = milliseconds / 1000;
                Long minutes = seconds / 60;
                Long hours = minutes / 60;
                Long days = hours / 24;  
                timer.Minutes__c = timer.Minutes__c + minutes;              
                timer.Timer_Start_Date_Time__c = null; // Assign the Start Date to null 
            }else if(timer.Timer_Started__c  && (oldTime == null || timer.Timer_Started__c != oldTime.get(timer.id).Timer_Started__c) && timer.Timer_Start_Date_Time__c == null){
                // If timer is Started Assign the Start Date to Current Date time
                timer.Timer_Start_Date_Time__c = system.now();
            }                               
        }
                            
    }

}