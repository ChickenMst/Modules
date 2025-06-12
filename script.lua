require "modules"

modules.libraries.callbacks:connect("onCreate", function(is_world_create)
	if is_world_create then
		modules.libraries.logging:info("onCreate()", "World created")
	else
		modules.libraries.logging:info("onCreate()", "Script reloaded")
	end
end)

modules.libraries.commands:create("test",{},"",function(full_message, peer_id, is_admin, is_auth, command, ...)
	local args = table.pack(...)
	if args[1] then
		modules.services.addons:enable("e")
	else
		modules.services.addons:disable("e")
	end
end)

modules.libraries.commands:create("purge",{},"purge gsave data",function(full_message, peer_id, is_admin, is_auth, command, ...)
	modules.libraries.gsave:_purgeGsave()
end)