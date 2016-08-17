/***************************************************************************

Description: Used to Generate the Time Sheet on Every Sunday

***************************************************************************/

global class ScheduleGenerateTimeSheet implements Schedulable {
   global void execute(SchedulableContext sc) {
        GenerateTimeSheetBatch generateTimeSht = new GenerateTimeSheetBatch();
        database.executebatch(generateTimeSht);        
   }
}