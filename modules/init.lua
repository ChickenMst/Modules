-- init modules table
modules = {}

require "modules.classes" -- load the classes
require "modules.libraries" -- load the libraries

modules.isDedicated = false -- is the server dedicated?

modules.addonReason = "unknown"

modules.onStart = modules.classes.event:create() -- event for when the server starts

-- add services and addons after loading everything else
require "modules.services" -- load the services
require "modules.addons" -- load the addons

-- internal function to set the isDedicated variable
function modules:_setIsDedicated()
    local host = server.getPlayers()[1]
    self.isDedicated = host and (host.steam_id == 0 and host.object_id == nil)
    modules.libraries.logging:info("modules.isDedicated", tostring(modules.isDedicated))
end

function modules:_setAddonReason(is_world_create)
    if is_world_create then
        self.addonReason = "create"
    else
        self.addonReason = "reload"
    end
    modules.libraries.logging:info("modules.addonReason", self.addonReason)
end

-- connect into onCreate for setup of modules
modules.libraries.callbacks:once("onCreate", function(is_world_create)
    modules:_setIsDedicated() -- set the isDedicated variable
    modules:_setAddonReason(is_world_create) -- set the addonReason variable

    if not g_savedata then
        modules.libraries.logging:warning("modules.onCreate", "g_savedata is not initialized, initializing.")
        -- setup gsave
        g_savedata = {
            modules = {
                services = {}
            }
        }
    end

    modules.onStart:fire()
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