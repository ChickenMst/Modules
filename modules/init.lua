-- init modules table
modules = {}

require "modules.libraries" -- load the libraries
require "modules.services" -- load the services
require "modules.addons" -- load the addons

-- run the tick function for all modules
---@usage modules:Tick()
function modules:Tick()
    modules.services:TickServices()
    modules.addons:TickAddons()
end