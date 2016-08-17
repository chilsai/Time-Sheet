/************************************************************************************

Author: Sai Sagar
Description: Test Class to test TimeEntryTrigger 

*************************************************************************************/
@isTest
public class TimeEntryTriggerHandlerTest{
    
    /*  Create New Time Entry Record -- Start Timer
     */ 
    static testmethod void TestUpdateTimerMinutesInsert(){
        
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
        tSheet.Weekend_Date__c = system.today().addDays(6);
        tSheet.Status__c = 'Pending Approval';       
        insert tSheet;
        
        test.StartTest();
            Time_Entry__c entry = new Time_Entry__c();
            entry.Timer_Started__c  = true;
            entry.Time_Sheet__c = tSheet.id;  
            entry.Date__c = system.today(); 
            entry.Team_Member__c =  tMembr.id;    
            insert entry;
        test.StopTest();   
        
        Time_Entry__c StartTime = [Select id,Timer_Start_Date_Time__c from Time_Entry__c  where id =: entry.Id];
        system.assert(StartTime.Timer_Start_Date_Time__c != null);
        
             
    }
    


    /*  Create New Time Entry Record -- Start Timer
     */ 
    static testmethod void TestUpdateTimerMinutesInsertBulk(){
        
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
        tSheet.Weekend_Date__c = system.today().addDays(6);
        tSheet.Status__c = 'Pending Approval';       
        insert tSheet;
        
        test.StartTest();
            list<Time_Entry__c> timeEntryList = new list<Time_Entry__c>();
            
            for(integer i=0; i< 200; i++){
                Time_Entry__c entry = new Time_Entry__c();
                entry.Timer_Started__c  = true;
                entry.Time_Sheet__c = tSheet.id;  
                entry.Date__c = system.today(); 
                entry.Team_Member__c =  tMembr.id;  
                timeEntryList.add(entry);
            }
            insert timeEntryList ;
        test.StopTest();   
        
        List<Time_Entry__c> StartTimeList = [Select id,Timer_Start_Date_Time__c from Time_Entry__c  where id =: timeEntryList];
        for(Time_Entry__c StartTime: StartTimeList ){
            system.assert(StartTime.Timer_Start_Date_Time__c != null);
        }        
        
             
    }    
    
   /*  Update Time Entry Record - Stop Timer
    */ 
    
    static testmethod void TestUpdateTimerMinutesUpdate(){
        
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
            entry.Timer_Started__c  = false; 
            update entry;          
        test.StopTest();   
        
        Time_Entry__c StartTime = [Select id,Timer_Start_Date_Time__c from Time_Entry__c  where id =: entry.Id];
        system.assert(StartTime.Timer_Start_Date_Time__c == null);
        
             
    }    
        
}