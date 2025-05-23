-- init modules table
modules = {}

require "modules.classes" -- load the classes
require "modules.libraries" -- load the libraries
require "modules.services" -- load the services
require "modules.addons" -- load the addons

modules.isDedicated = false -- is the server dedicated?

function modules:setIsDedicated()
    local host = server.getPlayers()[1]
    self.isDedicated = host and (host.steam_id == 0 and host.object_id == nil)
end

modules.libraries.callbacks:once("onCreate", function()
    modules:setIsDedicated() -- set the isDedicated variable
end)