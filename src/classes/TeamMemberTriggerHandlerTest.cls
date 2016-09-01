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
            SObjectDomain.Test.Database.onInsert(new Team_Member__c[] { tMembr } );    
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
            SObjectDomain.Test.Database.onDelete(new map<id,Team_Member__c>(new Team_Member__c[] { tMembr }) );        
            delete tMembr;             
        Test.StopTest();    

        // Assert User Should be removed part of Project Share
        list<Project__Share> pShare = [Select id,UserOrGroupId from Project__Share  where userorgroupid =: stdUser.Id AND parentId =: proj.Id];        
        system.assert(pShare.size() == 0);    
    }
    
    
    static testmethod void TestTeamMemberShareUpdate(){
        User adminUser = [Select id from user where id =: userinfo.getUserId()];
        User stdUser = new User();
        User stdUser2 = new User();
        system.RunAs(adminUser){
            Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
            stdUser = new User(Alias = 'standt', Email='standarduser@projts.com', 
                        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                        LocaleSidKey='en_US', ProfileId = p.Id, 
                        TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@projts.com');            
                        
                        
            insert stdUser;  
            stdUser2 = new User(Alias = 'standt2', Email='standarduser2@projts.com', 
                        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                        LocaleSidKey='en_US', ProfileId = p.Id, 
                        TimeZoneSidKey='America/Los_Angeles', UserName='standarduser2@projts.com');            
                        
                        
            insert stdUser2;                    
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
        
        Team_Member__c oldMembr = tMembr;
        Test.StartTest();            
            tMembr.projts__Employee__c = stdUser2.Id; 
            SObjectDomain.Test.Database.onUpdate(new Team_Member__c[] { tMembr },new map<id,Team_Member__c>(new Team_Member__c[] { oldMembr }) );        
            update tMembr;             
        Test.StopTest();    

        // Assert User Should be removed part of Project Share
        list<Project__Share> pShare = [Select id,UserOrGroupId from Project__Share  where userorgroupid =: stdUser2.Id AND parentId =: proj.Id];        
        system.assert(pShare.size() == 1);    
    }    

    public static void testErrorLogging()
    {   
        // Test static helpers for raise none domain object instance errors
        Team_Member__c tMembr = new Team_Member__c();
           
        SObjectDomain.Errors.error('Error', tMembr);
        SObjectDomain.Errors.error('Error', tMembr, Team_Member__c.Billing_Rate__c);
        System.assertEquals(2, SObjectDomain.Errors.getAll().size());       
        System.assertEquals('Error', SObjectDomain.Errors.getAll()[0].message);
        System.assertEquals('Error', SObjectDomain.Errors.getAll()[1].message);
        System.assertEquals(Team_Member__c.Billing_Rate__c, ((SObjectDomain.FieldError)SObjectDomain.Errors.getAll()[1]).field);
        SObjectDomain.Errors.clearAll();        
        System.assertEquals(0, SObjectDomain.Errors.getAll().size());       
    }           
}