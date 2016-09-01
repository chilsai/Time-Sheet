trigger TimeEntryTrigger on Time_Entry__c (after delete, after insert, after update, before delete, before insert, before update) {    
        
    // Creates Domain class instance and calls apprpoprite overideable methods according to Trigger state
    SObjectDomain.triggerHandler(TimeEntries.class);    
    
}