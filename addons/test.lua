local addon = modules.services.addon:createAddon("test", 1, "Test Addon", {"ChickenMst"})

function addon:initAddon()
end

function addon:startAddon()
    modules.libraries.logging:info("test", "Test addon started")
end