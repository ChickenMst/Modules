modules.libraries.addons = {} -- table of addon functions

modules.libraries.addons.addons = {} -- table of addons

function modules.libraries.addons:create(...)
    local addon = modules.classes.addon:create(...)
    return addon
end

---@param name string
---@param addon table
function modules.libraries.addons:connect(name, addon)
    if not self.addons[name] then
        self.addons[name] = addon -- add the addon to the addons table
    else
        modules.libraries.logging:error("modules.libraries.addons:connect()", "Addon " .. name .. " already exists") -- print an error to the console
    end
end

---@param name string
function modules.libraries.addons:disconnect(name)
    if self.addons[name] then
        self.addons[name] = nil -- remove the addon from the addons table
    else
        modules.libraries.logging:error("modules.libraries.addons:disconnect()", "Addon " .. name .. " does not exist") -- print an error to the console
    end
end

---@param name string
function modules.libraries.addons:enable(name)
    if self.addons[name] then
        self.addons[name].enable() -- enable the addon
    else
        modules.libraries.logging:error("modules.libraries.addons:enable()", "Addon " .. name .. " does not exist") -- print an error to the console
    end
end

---@param name string
function modules.libraries.addons:disable(name)
    if self.addons[name] then
        self.addons[name].disable() -- disable the addon
    else
        modules.libraries.logging:error("modules.libraries.addons:disable()", "Addon " .. name .. " does not exist") -- print an error to the console
    end
end