({
    select : function(component,event,helper) {
        var workspaceAPI = component.find("workspace");
        workspaceAPI.isConsoleNavigation().then(function(response) {
            if(response)
            {
                workspaceAPI.getEnclosingTabId().then(function(tabId) {
                    workspaceAPI.openSubtab({                    
                        parentTabId: tabId,                    
                        recordId : component.get("v.item.productId"),                    
                        focus: true                    
                    });
                });
            }
            else
            {
                var navEvt = $A.get("e.force:navigateToSObject");
                navEvt.setParams({
                    "recordId": component.get("v.item.productId"),
                    "slideDevName": "detail"
                });
                navEvt.fire();
            }
            
        })
        .catch(function(error) {            
            
        });
    }
    
    
})