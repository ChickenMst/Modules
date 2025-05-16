modules.services.addons = {}

modules.libraries.callbacks:connect("onCreate", function()
    for name, addon in pairs(modules.libraries.addons.addons) do
        if addon.enabled then
            modules.libraries.logging:debug("services.addons", "Loading addon: "..name)
            local addonloaded = addon.func:init() -- runs the init function of the addon
            if addonloaded then
                modules.libraries.logging:debug("services.addons", "Addon "..name.." loaded")
            else
                modules.libraries.logging:error("services.addons", "Addon "..name.." failed to load, disableing addon")
                modules.libraries.addons:disable(name) -- disable the addon if it fails to load
                modules.libraries.logging:debug("services.addons", "Addon "..name.." disabled")
            end
        else
            modules.libraries.logging:debug("services.addons", "Skiped loading addon: "..name..", addon is not enabled")
        end
    end
end)