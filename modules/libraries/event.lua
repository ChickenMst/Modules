modules.libraries.event = {} -- table of event functions

function modules.libraries.event:create()
    return modules.classes.event:create() -- create a new event object 
end

modules.libraries.event.removeConnection = {}