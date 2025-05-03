-- initialize the main modules table
modules.main = {}

require "modules.main.Libraries" -- load the library functions
require "modules.main.services" -- load the services

-- run the tick function for all modules in main
---@usage modules.main:Tick() 
function modules.main:Tick()
    modules.main.services:TickServices() -- run the tick function for all loaded services
end