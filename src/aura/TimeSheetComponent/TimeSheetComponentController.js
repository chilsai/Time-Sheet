({
   doInit: function(component, event, helper) {  
       var toDay = new Date();
       var hostName = window.location.hostname; 
       console.log('SSSSSSSSSSS'+hostName);
       component.set("v.HostName", hostName); 
      //Fetch the expense list from the Apex controller   
      helper.getTimeEntryList(component);
      helper.getProjectList(component);      
   },
     
    // To Show Model Window for New Time Entry
    showModal : function(component, event, helper) {        
        document.getElementById("backGroundSectionId").style.display = "block";
        document.getElementById("newTimeSectionId").style.display = "block";
    },
    
    // To Hide Model Window
	showModalBox : function(component, event, helper) {
		document.getElementById("backGroundSectionId").style.display = "none";
		document.getElementById("newTimeSectionId").style.display = "none";
	},
    
    // Render Button to Create New Time entry
	checkNullValue : function(component, event, helper) {
		console.log('SSSS'+component.get("v.Hours"));
	},    
  	
    // Get Tasks on project Change
	getTasks: function(component, event, helper) {               
      //Fetch the expense list from the Apex controller    
      console.log('@@@'+component.get("v.SelectedTimeSheet"));     
      helper.getTaksList(component);      
    },  
    
    // To Stop/Pause the Timer
	StopTimer : function(component, event, helper) {		
        var idx = event.target.id;
		console.log('in start in  LOf'+idx);
		var action = component.get("c.stopTimer");
    	action.setParams({ "timerId" : idx});        
        action.setCallback(this, function(a) {
            if (a.getState() === "SUCCESS") {
                console.log('in success');
            } else if (a.getState() === "ERROR") {
                $A.log("Errors", a.getError());
            }
        }); 
        $A.enqueueAction(action);
        helper.getTimeEntryList(component);
	},    

    // To Start/Resume the Timer 
	StartTimer : function(component, event, helper) {		
        var idx = event.target.id;
		console.log('in start in  LOf'+idx);
		var action = component.get("c.startTimer");
    	action.setParams({ "timerId" : idx});        
        action.setCallback(this, function(a) {
            if (a.getState() === "SUCCESS") {
                console.log('in success');
            } else if (a.getState() === "ERROR") {
                $A.log("Errors", a.getError());
            }
        }); 
        $A.enqueueAction(action);
        helper.getTimeEntryList(component);
	},
    
    // To Create New Time Entry with Time in Hours
    createNewTimeEntry : function(component, event, helper) {     
    	var action = component.get("c.createNewTimer");        
    	action.setParams({ TimeSheetId : component.get("v.SelectedTimeSheet"),
                           TaskId :  component.get("v.SelectedTask")
                         });             
        action.setCallback(this, function(a) {
            if (a.getState() === "SUCCESS") {
                helper.getTimeEntryList(component);
                document.getElementById("backGroundSectionId").style.display = "none";
                document.getElementById("newTimeSectionId").style.display = "none";                
            } else if (a.getState() === "ERROR") {
                $A.log("Errors", a.getError());
            }
        });     
    	$A.enqueueAction(action);
    }
})