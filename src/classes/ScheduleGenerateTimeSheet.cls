/**
 * Class implements the required interfaces for Scheduling and executing in Batch
 *
 * NOTE: The server and selector methods are reused, logic in this batch class is thus very light,
 *        focusing on passing paramters in and handling errors and notfications
 *
 **/ 

global class ScheduleGenerateTimeSheet implements Schedulable {
    
   // Start the job once the scheduled time has arrived 
    global void execute(SchedulableContext sc) {
        GenerateTimeSheetBatch generateTimeSht = new GenerateTimeSheetBatch();
        database.executebatch(generateTimeSht);        
    }
    
}