modules.services.addons = {}

modules.libraries.callbacks:connect("onCreate", function(is_world_create)
    if is_world_create then
        modules.libraries.logging:info("onCreate()", "World created")
    else
        for name, addon in pairs(modules.libraries.addons.addons) do
            if addon.is_enabled then
                addon.func.init() -- enable the addon
            end
        end
    end
end)