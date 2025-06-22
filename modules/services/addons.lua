modules.services.addons = modules.services:createService("addons", "Addons Service", {"ChickenMst"})

function modules.services.addons:initService()
    self.addons = {} ---@type table <string, Addon>
end

function modules.services.addons:startService()
    for name, addon in pairs(self.addons) do
        if addon.enabled then
            modules.libraries.logging:debug("services.addons", "Loading addon: "..name)
            local addonloaded = addon:init() -- runs the init function of the addon
            if addonloaded then
                modules.libraries.logging:debug("services.addons", "Addon "..name.." loaded")
            else
                modules.libraries.logging:warning("services.addons", "Addon "..name.." failed to load, disableing addon")
                self:disable(name) -- disable the addon if it fails to load
            end
        else
            modules.libraries.logging:debug("services.addons", "Skiped loading addon: "..name..", addon is not enabled")
        end
    end
end

---@param name string
---@param addon Addon
function modules.services.addons:connect(name, addon)
    if not self.addons[name] then
        self.addons[name] = addon -- add the addon to the addons table
    else
        modules.libraries.logging:error("services.addons:connect()", "Addon " .. name .. " already exists") -- print an error to the console
    end
end

---@param name string
function modules.services.addons:disconnect(name)
    if self.addons[name] then
        self.addons[name]:removeConnections() -- remove all connections of the addon
        self.addons[name]:removeCommands() -- remove all commands of the addon
        self.addons[name] = nil -- remove the addon from the addons table
        modules.libraries.logging:debug("services.addons:disconnect()", "Addon " .. name .. " disconnected") -- print a debug message to the console
    else
        modules.libraries.logging:error("services.addons:disconnect()", "Addon " .. name .. " does not exist") -- print an error to the console
    end
end

---@param name string
function modules.services.addons:enable(name)
    if self.addons[name] then
        if self.addons[name].enabled then
            modules.libraries.logging:debug("services.addons:enable()", "Addon " .. name .. " is already enabled") -- print a debug message to the console
            return
        end
        self.addons[name]:enable() -- enable the addon
        self.addons[name]:init() -- run the init function of the addon
        modules.libraries.logging:debug("services.addons:enable()", "Addon " .. name .. " enabled") -- print a debug message to the console
        return
    else
        modules.libraries.logging:error("services.addons:enable()", "Addon " .. name .. " does not exist") -- print an error to the console
    end
end

---@param name string
function modules.services.addons:disable(name)
    if self.addons[name] then
        if not self.addons[name].enabled then
            modules.libraries.logging:debug("services.addons:disable()", "Addon " .. name .. " is already disabled") -- print a debug message to the console
            return
        end
        self.addons[name]:disable() -- disable the addon
        self.addons[name]:removeConnections() -- remove all connections of the addon
        self.addons[name]:removeCommands() -- remove all commands of the addon
        modules.libraries.logging:debug("services.addons:disable()", "Addon " .. name .. " disabled") -- print a debug message to the console
        return
    else
        modules.libraries.logging:error("services.addons:disable()", "Addon " .. name .. " does not exist") -- print an error to the console
    end
end