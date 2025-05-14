modules.services.addons = {}

modules.libraries.callbacks:connect("onCreate", function(is_world_create)
    if is_world_create then
    else
        ---@param addon Addon
        for name, addon in pairs(modules.libraries.addons.addons) do
            if addon.enabled then
                addon.func:init() -- enable the addon
            end
        end
    end
end)