({
   //Fetch the Time Entered from the Apex controller
  getTimeEntryList: function(component) {
    var action = component.get("c.getTimeEntries");

    //Set up the callback
    var self = this;
    action.setCallback(this, function(actionResult) {
        component.set("v.timeReport", actionResult.getReturnValue()); 
        if(actionResult.getReturnValue()){
            var weekEndDate = new Date(actionResult.getReturnValue().weekEndDate);            
            console.log(actionResult.getReturnValue());            
        }
    });	    
    $A.enqueueAction(action);
  } ,  
    
   //Fetch the Project from the Apex controller
  getProjectList: function(component) {
    var action = component.get("c.getProjectList");

    //Set up the callback
    var self = this;
    action.setCallback(this, function(actionResult) {
        component.set("v.timeSheetList", actionResult.getReturnValue());
		if(actionResult.getReturnValue() && actionResult.getReturnValue().length > 0){        
        	component.set("v.SelectedTimeSheet", actionResult.getReturnValue()[0].Id);  
        }
        this.getTaksList(component);
    }); 
    $A.enqueueAction(action);
  } ,
    
   //Fetch the Tasks selected Project from the Apex controller
  getTaksList: function(component) {
    var action = component.get("c.getTaksList");
    //Set up the callback
    var self = this;
    action.setCallback(this, function(actionResult) {
        component.set("v.taskList", actionResult.getReturnValue()); 
        if(actionResult.getReturnValue() && actionResult.getReturnValue().length > 0){
			component.set("v.SelectedTask", actionResult.getReturnValue()[0].Id);                     
        }        
    });     
    action.setParams({"TimeSheetId": component.get("v.SelectedTimeSheet")});      
    $A.enqueueAction(action);
  }       
})