local addon = modules.libraries.addons:create("e",1,"aussieworks","Addon e")
addon.connect(function()
    init = function()
        modules.libraries.logging:info("init()", "Addon e initialized")
    end
    modules.libraries.logging:info("Addon loaded", "Addon e has been loaded successfully.")
end)

modules.libraries.addons:connect("e", addon) -- connect the addon to the addons table
modules.libraries.addons:enable("e") -- enable the addon