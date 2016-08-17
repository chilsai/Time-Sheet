/************************************************************************************

Author: Sai Sagar
Description: Test Class to test TeamMemberTriggerHandler

*************************************************************************************/
@isTest
public class TeamMemberTriggerHandlerTest{
    
    
    static testmethod void TestTeamMemberShareInsert(){

        User adminUser = [Select id from user where id =: userinfo.getUserId()];
        User stdUser = new User();
        system.RunAs(adminUser){
            Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
            stdUser = new User(Alias = 'standt', Email='standarduser@projts.com', 
                        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                        LocaleSidKey='en_US', ProfileId = p.Id, 
                        TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@projts.com');            
                        
                        
            insert stdUser;        
        }

        Project__c proj = new Project__c();
        proj.Name = 'Web Service';
        proj.Project_Code__c = 'PROJ1211';
        proj.projts__Project_Manager__c = userInfo.getUserId();        
        insert proj;                                
        
        Test.StartTest();
            Team_Member__c tMembr = new Team_Member__c();
            tMembr.projts__Billing_Rate__c = 100;
            tMembr.projts__Project__c = proj.id;
            tMembr.projts__Employee__c = stdUser.Id;
            insert tMembr;    
        Test.StopTest();                    
        
        
        // Assert User Should be part of Project Share 
        list<Project__Share> pShare = [Select id,UserOrGroupId from Project__Share  where userorgroupid =: stdUser.Id AND parentId =: proj.Id];        
        system.assert(pShare.size() == 1);
    }
    
    static testmethod void TestTeamMemberShareDelete(){
        User adminUser = [Select id from user where id =: userinfo.getUserId()];
        User stdUser = new User();
        system.RunAs(adminUser){
            Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
            stdUser = new User(Alias = 'standt', Email='standarduser@projts.com', 
                        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                        LocaleSidKey='en_US', ProfileId = p.Id, 
                        TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@projts.com');            
                        
                        
            insert stdUser;        
        }
        
        Project__c proj = new Project__c();
        proj.Name = 'Web Service';
        proj.Project_Code__c = 'PROJ1211';
        proj.projts__Project_Manager__c = userInfo.getUserId();        
        insert proj;         
                                       
        Team_Member__c tMembr = new Team_Member__c();
        tMembr.projts__Billing_Rate__c = 100;
        tMembr.projts__Project__c = proj.id;
        tMembr.projts__Employee__c = stdUser.Id;
        insert tMembr;    
        
        Test.StartTest(); 
            delete tMembr;         
        Test.StopTest();    

        // Assert User Should be removed part of Project Share
        list<Project__Share> pShare = [Select id,UserOrGroupId from Project__Share  where userorgroupid =: stdUser.Id AND parentId =: proj.Id];        
        system.assert(pShare.size() == 0);    
    }
           
}