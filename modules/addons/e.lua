local addon = modules.libraries.addons:create("e",1,"aussieworks","Addon e")

local addonfunc = {}

function addonfunc:init()
    
end

addon:connect(addonfunc)

modules.libraries.addons:connect("e", addon) -- connect the addon to the addons table
modules.libraries.addons:enable("e") -- enable the addon