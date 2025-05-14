modules.services.addons = {}

modules.libraries.callbacks:connect("onCreate", function(is_world_create)
    if is_world_create then
    else
        ---@param addon Addon
        ---@param name string
        for name, addon in pairs(modules.libraries.addons.addons) do
            if addon.enabled then
                modules.libraries.logging:info("services.addons", "Loading addon: "..name) -- print to the console
                local addonloaded = addon.func:init() -- enable the addon
                if addonloaded then
                    modules.libraries.logging:info("services.addons", "Addon "..name.." loaded") -- print to the console
                else
                    modules.libraries.logging:error("services.addons", "Addon "..name.." failed to load") -- print to the console
                end
            else
                modules.libraries.logging:info("services.addons", "Skiped loading addon: "..name..", addon is not enabled") -- print to the console
            end
        end
    end
end)