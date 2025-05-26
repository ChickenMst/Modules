require "modules"

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

modules.libraries.callbacks:connect("onCreate", function(is_world_create)
	if is_world_create then
		modules.libraries.logging:info("onCreate()", "World created")
	else
		modules.libraries.logging:info("onCreate()", "Script reloaded")
	end
end)