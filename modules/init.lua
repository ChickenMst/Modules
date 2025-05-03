-- init modules table
modules = {}

require "modules.main"
require "modules.addons" -- load the addons

-- run the tick function for all modules
---@usage modules:Tick()
function modules:Tick()
    modules.main:Tick()
    modules.addons:TickAddons()
end