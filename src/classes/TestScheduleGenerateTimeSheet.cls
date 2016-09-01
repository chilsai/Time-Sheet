/*
 *  Test class to Test ScheduleGenerateTimeSheet and GenerateTimeSheetBatch
 *
 */
 
@isTest
private class TestScheduleGenerateTimeSheet {

    @testSetup static void LoadDateForTimeEntries() {
        Project__c proj = new Project__c();
        proj.Name = 'Web Service';
        proj.Project_Code__c = 'PROJ1211';
        proj.projts__Project_Manager__c = userInfo.getUserId();
        proj.End_Date__c  = system.today().adddays(10);        
        insert proj;                                
        
        Team_Member__c tMembr = new Team_Member__c();
        tMembr.projts__Billing_Rate__c = 100;
        tMembr.projts__Project__c = proj.id;
        tMembr.projts__Employee__c = userInfo.getUserId();
        insert tMembr;
        
        Task__c tsk = new Task__c();
        tsk.name = 'Development';
        insert tsk;                     
     }    


    static testmethod void ScheduleGenerateTimeSheetTest() {         
        test.startTest();
            ScheduleGenerateTimeSheet generateTimSheet = new ScheduleGenerateTimeSheet();
            String sch = '0 0 23 * * ?'; 
            system.schedule('Generate Time Sheet', sch, generateTimSheet); 
        test.stopTest();                    
    }
}