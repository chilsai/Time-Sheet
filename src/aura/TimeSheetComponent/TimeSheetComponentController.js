({
   doInit: function(component, event, helper) {  
       var toDay = new Date();
      component.set("v.currentDate", toDay); 
      //Fetch the expense list from the Apex controller   
      helper.getTimeEntryList(component);
   },
   showDetails: function(component, event, helper) {
        //Get data via "data-data" attribute from button (button itself or icon's parentNode)
        var id = event.target.getAttribute("data-data") || event.target.parentNode.getAttribute("data-data")
        alert(id + " was passed");
   }, 
    
    showModal : function(component, event, helper) {        
        document.getElementById("backGroundSectionId").style.display = "block";
        document.getElementById("newAccountSectionId").style.display = "block";
    },
    
	showModalBox : function(component, event, helper) {
		document.getElementById("backGroundSectionId").style.display = "none";
		document.getElementById("newAccountSectionId").style.display = "none";
	}, 
    saveAccount : function(component, event, helper) {     
    	var action = component.get("c.getAccountupdatedlist");
    	action.setParams({ "newAcc" : component.get("v.newAccount")});     
    action.setCallback(this, function(a) {
        if (a.getState() === "SUCCESS") {
        	document.getElementById("backGroundSectionId").style.display = "none";
        	document.getElementById("newAccountSectionId").style.display = "none";
        } else if (a.getState() === "ERROR") {
        	$A.log("Errors", a.getError());
        }
    });     
    $A.enqueueAction(action);
    }    


    
})