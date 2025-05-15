require "modules"

modules.libraries.callbacks:connect("onCreate", function(is_world_create)
	if is_world_create then
		modules.libraries.logging:info("onCreate()", "World created")
	else
		modules.libraries.logging:info("onCreate()", "Script reloaded")
	end
end)

modules.libraries.commands:create("test", {"t","te","tes"}, "Test command", function(full_message, peer_id, is_admin, is_auth, command, ...)
	args = table.pack(...)
	modules.libraries.logging:info("test()", "Test command executed by " .. peer_id .. " with command: " .. command)
	modules.libraries.logging:setLogLevel(args[1])
end)