/**
 * Class implements the required interfaces for Scheduling and executing in Batch
 * Description: Used to Generate the Time Sheet on Every Sunday
 *
 * NOTE: The service and selector methods are reused, logic in this batch class is thus very light,
 *        focusing on passing paramters in and handling errors and notfications
 *
 **/ 

global class GenerateTimeSheetBatch implements Database.Batchable<sObject>,Database.Stateful{


    // Simple job log for errors
    private List<JobError> jobErrors = new List<JobError>();
        
    global Database.QueryLocator start(Database.BatchableContext BC){
        date Today = System.today();        
        string TodayString = string.ValueOf(Today);                
        return new ProjectSelector().getNonExpiredProjectS(Today);
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope){
        list<Project__c> projList = (List<Project__c>)scope;
        try{
            TimeSheetService.createTimeSheetForProject(new map<Id,Project__c>(projList).keyset());
        }catch(Exception e){
            // Capture context and error for reporting once job complete
            JobError jobError = new JobError();
            jobError.records = projList;
            jobError.message = e.getMessage();
            jobErrors.add(jobError);
        }
    }
    
    global void finish(Database.BatchableContext BC){
        // Notify Job Status 
    }
    
    /**
     * Simple wrapper class containing the error message and the records in scope at the time
     **/
    public class JobError
    {
        public String message;      
        public List<Project__c> records;
    }    
}