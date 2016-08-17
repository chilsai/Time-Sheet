/***************************************************************************

Description: Used to Generate the Time Sheet on Every Sunday

***************************************************************************/

global class GenerateTimeSheetBatch implements Database.Batchable<sObject>{

    
    global Database.QueryLocator start(Database.BatchableContext BC){
        date Today = System.today();        
        string TodayString = string.ValueOf(Today);                
        
        string query  = 'Select id,Name,Start_Date__c,End_Date__c from project__c where End_Date__c > '+TodayString ;
        system.debug('SSSSSS'+query  );
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope){
        list<Project__c > projList = new List<Project__c>();
        list<Time_Sheet__c> timeSheetList = new list<Time_Sheet__c>();                   
        for(sObject proj: scope){
            Project__c pr = (Project__c)proj;
            Time_Sheet__c tSheet = new Time_Sheet__c();
            tSheet.Project__c = pr.id;
            tSheet.Weekend_Date__c = system.today().addDays(6);
            timeSheetList.add(tSheet);       
        }             
        insert timeSheetList;
        system.debug('timeSheetList********'+timeSheetList);
    }
    
    global void finish(Database.BatchableContext BC){
    
    }
}