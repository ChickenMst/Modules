modules.libraries.events = {} -- table of event functions

function modules.libraries.events:create()
    return modules.classes.event:create() -- create a new event object 
end

modules.libraries.events.removeConnection = {}