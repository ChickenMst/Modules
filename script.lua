require "modules"

modules.libraries.callbacks:connect("onCreate", function(is_world_create)
	if is_world_create then
		modules.libraries.logging:info("onCreate()", "World created")
	else
		modules.libraries.logging:info("onCreate()", "Script reloaded")
	end
end)

modules.libraries.callbacks:connect("onChatMessage", function(peer_id, sender_name, message)
	modules.libraries.logging:info("onChatMessage()", "Player: " .. sender_name .. " sent a message: " .. message)
end)

modules.libraries.commands:create("test", {"t","te","tes"}, "Test command", function(full_message, peer_id, is_admin, is_auth, command, ...)
	modules.libraries.logging:info("test()", "Test command executed by " .. peer_id .. " with message: " .. command)
end)