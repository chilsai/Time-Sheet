trigger TimeEntryTrigger on Time_Entry__c (before insert,before update) {
    
    if(Trigger.IsBefore && (Trigger.IsUpdate || Trigger.Isinsert)){
        TimeEntryTriggerHandler.UpdateTimerMinutes(trigger.new,trigger.oldmap);
    }
    
}