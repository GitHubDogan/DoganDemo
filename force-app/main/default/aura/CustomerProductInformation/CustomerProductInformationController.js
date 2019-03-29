({
    doInit : function(component,event,helper) {
        // create a one-time use instance of the serverEcho action
        // in the server-side controller
        var action = component.get("c.getCustomerProducts");
        action.setParams({ caseId : component.get("v.recordId") });
        // Create a callback that is executed after 
        // the server-side action returns
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.customer", response.getReturnValue().customer);
				component.set("v.result",JSON.stringify(response.getReturnValue().customer));
            }
            else if (state === "INCOMPLETE") {
                
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    }    
})