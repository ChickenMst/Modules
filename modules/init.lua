-- init modules table
modules = {}

require "modules.classes" -- load the classes
require "modules.libraries" -- load the libraries
require "modules.services" -- load the services
require "modules.addons" -- load the addons

modules.isDedicated = false -- is the server dedicated?

-- internal function to set the isDedicated variable
function modules:_setIsDedicated()
    local host = server.getPlayers()[1]
    self.isDedicated = host and (host.steam_id == 0 and host.object_id == nil)
    modules.libraries.logging:info("modules.isDedicated", tostring(modules.isDedicated))
end

-- connect into onCreate for setup of modules
modules.libraries.callbacks:once("onCreate", function()
    modules:_setIsDedicated() -- set the isDedicated variable

    if not g_savedata then
        -- setup gsave
        g_savedata = {
            modules = {
                services = {}
            }
        }
    end
end)

-- SSSWTool tracing support, since modules messes with callbacks via `_ENV` at runtime.
if SSSW_DBG then
    if SSSW_DBG.level == "full" then
        SSSW_DBG.expected_stack_onTick = {"_ENV[name]", "`existing(...)`"}
    else
        SSSW_DBG.expected_stack_onTick = {"_ENV[name]"}
    end
    SSSW_DBG.expected_stack_httpReply = SSSW_DBG.expected_stack_onTick
	modules.libraries.callbacks:_initCallback("onTick")
	modules.libraries.callbacks:_initCallback("httpReply")
end