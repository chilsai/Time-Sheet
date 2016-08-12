public with sharing class TimeSheetController {
    @AuraEnabled
    public static weekTimeReport getTimeEntries(date currentDate ) {        
        if(currentDate ==  null){
            currentDate = system.today();
        }
        
        Date startDate = currentDate.toStartOfWeek();
        list<Time_Entry__c> timeEntries = new list<Time_Entry__c>();
        weekTimeReport weekRprt;
        timeEntries = [select id,Employee__c,Date__c,Minutes__c,Time__c,Task__r.Name,Time_Sheet__r.Project__r.Name from Time_Entry__c 
                       where Employee__c =: userInfo.getUserId()];
        
        string totalHours ;
        decimal totalMinutes = 0;
        for(Time_Entry__c te: timeEntries ){
            if(te.Minutes__c != null){
                totalMinutes = totalMinutes+te.Minutes__c;
            }        
        }
        decimal hours = math.floor(totalMinutes /60);
        integer minuts = math.MOD(integer.valueOf(totalMinutes ),60);
        totalHours  = string.valueOf(hours) +':' +string.valueOf(minuts);        
        weekRprt = new weekTimeReport(totalHours,startDate ,timeEntries);
        
       return weekRprt ;
    } 
        
}