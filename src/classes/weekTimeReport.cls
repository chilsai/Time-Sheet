public with sharing class weekTimeReport{
    
    @AuraEnabled
    public string totalHours;
    @AuraEnabled
    public date startDate;
    @AuraEnabled
    public date weekEndDate;    
    @AuraEnabled
    public List<Time_Entry__c> timeEntries;    
    
    public weekTimeReport(string totalHours,date startDate,List<Time_Entry__c> timeEntries){
        this.totalHours = totalHours;
        this.startDate = startDate;
        if(startDate != null){
            this.weekEndDate = startDate.addDays(7);
        }
        this.timeEntries = timeEntries;                        
    }                   

}