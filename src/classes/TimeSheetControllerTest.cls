/************************************************************************************

Author: Sai Sagar
Description: Test Class to test TimeSheetController

*************************************************************************************/
@isTest
public class TimeSheetControllerTest{
    


    @testSetup static void LoadDateForTimeEntries() {
        Project__c proj = new Project__c();
        proj.Name = 'Web Service';
        proj.Project_Code__c = 'PROJ1211';
        proj.projts__Project_Manager__c = userInfo.getUserId();        
        insert proj;                                
        
        Team_Member__c tMembr = new Team_Member__c();
        tMembr.projts__Billing_Rate__c = 100;
        tMembr.projts__Project__c = proj.id;
        tMembr.projts__Employee__c = userInfo.getUserId();
        insert tMembr;
        
        Task__c tsk = new Task__c();
        tsk.name = 'Development';
        insert tsk;
        
        Time_Sheet__c tSheet = new Time_Sheet__c();
        tSheet.Project__c = proj.Id; 
        tSheet.Weekend_Date__c = system.today().toStartOfWeek().addDays(6);
        tSheet.Status__c = 'Pending Approval';       
        insert tSheet;
        
        list<Time_Entry__c> timeEntryList = new list<Time_Entry__c>();
        
        for(integer i=0; i< 200; i++){
            Time_Entry__c entry = new Time_Entry__c();
            entry.Minutes__c = 122;
            entry.Time_Sheet__c = tSheet.id;  
            entry.Date__c = system.today(); 
            entry.Team_Member__c =  tMembr.id;  
            timeEntryList.add(entry);
        }
        insert timeEntryList ;   
    
    }    
    

    static testmethod void TestgetTimeEntries(){ 
        weekTimeReport  Report;
        
        test.StartTest();
            Report = TimeSheetController.getTimeEntries();
        test.StopTest();
        
        Date startDate = System.today().toStartOfWeek();
        system.assertEquals(Report.startDate,startDate);
    }


    static testmethod void TestgetProjectList(){ 
        List<Time_Sheet__c> timeSheetList;
        
        test.StartTest();
            timeSheetList = TimeSheetController.getProjectList();
        test.StopTest();
        system.assert(timeSheetList.size() == 1);
    }
    
    static testmethod void TestgetTaksList(){
    
        Project__c proj = new Project__c();
        proj.Name = 'Web Service';
        proj.Project_Code__c = 'PROJ1211';
        proj.projts__Project_Manager__c = userInfo.getUserId();        
        insert proj;                                
        
        Team_Member__c tMembr = new Team_Member__c();
        tMembr.projts__Billing_Rate__c = 100;
        tMembr.projts__Project__c = proj.id;
        tMembr.projts__Employee__c = userInfo.getUserId();
        insert tMembr;
        
        Task__c tsk = new Task__c();
        tsk.name = 'Development';
        tsk.Project__c = proj.Id;
        insert tsk;
        
        Time_Sheet__c tSheet = new Time_Sheet__c();
        tSheet.Project__c = proj.Id; 
        tSheet.Weekend_Date__c = system.today().addDays(6);
        tSheet.Status__c = 'Pending Approval';       
        insert tSheet;
             
        List<Task__c> taskList;
        
        test.StartTest();
            taskList = TimeSheetController.getTaksList(tSheet.id);
        test.StopTest();
        system.assert(taskList.size() == 1);
    }  
    
    
    static testmethod void TestcreateNewTimer(){
    
        Project__c proj = new Project__c();
        proj.Name = 'Web Service';
        proj.Project_Code__c = 'PROJ1211';
        proj.projts__Project_Manager__c = userInfo.getUserId();        
        insert proj;                                
        
        Team_Member__c tMembr = new Team_Member__c();
        tMembr.projts__Billing_Rate__c = 100;
        tMembr.projts__Project__c = proj.id;
        tMembr.projts__Employee__c = userInfo.getUserId();
        insert tMembr;
        
        Task__c tsk = new Task__c();
        tsk.name = 'Development';
        tsk.Project__c = proj.Id;
        insert tsk;
        
        Time_Sheet__c tSheet = new Time_Sheet__c();
        tSheet.Project__c = proj.Id; 
        tSheet.Weekend_Date__c = system.today().addDays(6);
        tSheet.Status__c = 'Pending Approval';       
        insert tSheet;             
        
        test.StartTest();
            TimeSheetController.createNewTimer(tSheet.id,tsk.Id);
        test.StopTest();
        
        List<Time_Entry__c>  entry = [Select id from Time_Entry__c where Time_Sheet__c =: tSheet.id AND Task__c =: tsk.Id];
        system.assert(entry.size() == 1);
    }  
    
    static testmethod void TestStopTimerTest(){
    
        Project__c proj = new Project__c();
        proj.Name = 'Web Service';
        proj.Project_Code__c = 'PROJ1211';
        proj.projts__Project_Manager__c = userInfo.getUserId();        
        insert proj;                                
        
        Team_Member__c tMembr = new Team_Member__c();
        tMembr.projts__Billing_Rate__c = 100;
        tMembr.projts__Project__c = proj.id;
        tMembr.projts__Employee__c = userInfo.getUserId();
        insert tMembr;
        
        Task__c tsk = new Task__c();
        tsk.name = 'Development';
        tsk.Project__c = proj.Id;
        insert tsk;
        
        Time_Sheet__c tSheet = new Time_Sheet__c();
        tSheet.Project__c = proj.Id; 
        tSheet.Weekend_Date__c = system.today().addDays(6);
        tSheet.Status__c = 'Pending Approval';       
        insert tSheet;             


        Time_Entry__c entry = new Time_Entry__c();
        entry.Timer_Started__c  = true;
        entry.Time_Sheet__c = tSheet.id;  
        entry.Date__c = system.today(); 
        entry.Team_Member__c =  tMembr.id;    
        insert entry;        
        
        test.StartTest();
            TimeSheetController.stopTimer(entry.id);
        test.StopTest();
        
        List<Time_Entry__c>  entryList = [Select id,Timer_Started__c   from Time_Entry__c where Id =: entry.id];
        system.assert(!entryList[0].Timer_Started__c  );
    }           
    

    static testmethod void TestStartTimerTest(){
    
        Project__c proj = new Project__c();
        proj.Name = 'Web Service';
        proj.Project_Code__c = 'PROJ1211';
        proj.projts__Project_Manager__c = userInfo.getUserId();        
        insert proj;                                
        
        Team_Member__c tMembr = new Team_Member__c();
        tMembr.projts__Billing_Rate__c = 100;
        tMembr.projts__Project__c = proj.id;
        tMembr.projts__Employee__c = userInfo.getUserId();
        insert tMembr;
        
        Task__c tsk = new Task__c();
        tsk.name = 'Development';
        tsk.Project__c = proj.Id;
        insert tsk;
        
        Time_Sheet__c tSheet = new Time_Sheet__c();
        tSheet.Project__c = proj.Id; 
        tSheet.Weekend_Date__c = system.today().addDays(6);
        tSheet.Status__c = 'Pending Approval';       
        insert tSheet;             


        Time_Entry__c entry = new Time_Entry__c();
        entry.Time_Sheet__c = tSheet.id;  
        entry.Date__c = system.today(); 
        entry.Team_Member__c =  tMembr.id;    
        insert entry;        
        
        test.StartTest();
            TimeSheetController.startTimer(entry.id);
        test.StopTest();
        
        List<Time_Entry__c>  entryList = [Select id,Timer_Started__c   from Time_Entry__c where Id =: entry.id];
        system.assert(entryList[0].Timer_Started__c  );
    }    
}