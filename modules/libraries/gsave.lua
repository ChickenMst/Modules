modules.libraries.gsave = {}

function modules.libraries.gsave:saveService(name, service)
    if type(g_savedata.modules.services[name]) == "nil" then
        g_savedata.modules.services[name] = {}
    end

    if type(service) == "table" then
        g_savedata.modules.services[name] = service
    end
end

function modules.libraries.gsave:loadService(name)
    local service = g_savedata.modules.services[name]

    return service
end