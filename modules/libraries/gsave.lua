modules.libraries.gsave = {}

function modules.libraries.gsave:saveService(name, service)
    self:_checkGsave(name)

    g_savedata.modules.services[name] = service
end

function modules.libraries.gsave:loadService(name)
    self:_checkGsave(name)

    if not g_savedata.modules.services[name] then
        modules.libraries.logging:debug("gsave:loadService", "Service '" .. name .. "' not found in g_savedata, returning empty table.")
        self:_fixGsave(name)
        return {}
    end

    return g_savedata.modules.services[name]
end

function modules.libraries.gsave:_checkGsave(name)
    if not g_savedata then
        self:_fixGsave(name)
    end

    if not g_savedata.modules then
        self:_fixGsave(name)
    end

    if not g_savedata.modules.services then
        self:_fixGsave(name)
    end
end

function modules.libraries.gsave:_fixGsave(name)
    if not g_savedata then
        g_savedata = {}
    end

    if not g_savedata.modules then
        g_savedata.modules = {}
    end

    if not g_savedata.modules.services then
        g_savedata.modules.services = {}
    end

    if name and not g_savedata.modules.services[name] then
        g_savedata.modules.services[name] = {}
    end
end

function modules.libraries.gsave:_purgeGsave()
    g_savedata = nil
    self:_fixGsave()
    modules.libraries.logging:info("gsave:_purgeGsave", "GSave data purged and reset.")
end