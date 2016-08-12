({
   //Fetch the accounts from the Apex controller
  getTimeEntryList: function(component) {
    var action = component.get("c.getTimeEntries");

    //Set up the callback
    var self = this;
    action.setCallback(this, function(actionResult) {
        component.set("v.timeReport", actionResult.getReturnValue()); 
        if(actionResult.getReturnValue()){
            var weekEndDate = new Date(actionResult.getReturnValue().weekEndDate);
            component.set("v.TotalHours", actionResult.getReturnValue().totalHours); 
            console.log(actionResult.getReturnValue());            
        }
    });
	    
    var currentDate ;     
    action.setParams({"currentDate": currentDate});
    console.log(currentDate);  
    $A.enqueueAction(action);
  }   
})