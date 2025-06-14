require "modules"

modules.libraries.callbacks:connect("onCreate", function(is_world_create)
	if is_world_create then
		modules.libraries.logging:info("onCreate()", "World created")
	else
		modules.libraries.logging:info("onCreate()", "Script reloaded")
	end
end)

modules.onStart:once(function()
	modules.libraries.commands:create("test",{},"",function(full_message, peer_id, is_admin, is_auth, command, ...)
		modules.libraries.logging:debug("test command", "Command executed by peer_id: " .. tostring(peer_id))
		local player = modules.services.player:getPlayerByPeer(peer_id)
		modules.libraries.logging:debug("test command", "Player info: " .. player.steamId .. ", " .. player.name .. ", " .. tostring(player.inGame))
	end)

	modules.libraries.commands:create("loglevel",{"ll"}, "set the log level", function(full_message, peer_id, is_admin, is_auth, command, ...)
		local args = {...}
		if #args == 0 then
			modules.libraries.logging:warning("loglevel", "No log level provided")
			return
		end
		local loglevel = args[1]:upper()
		modules.libraries.logging:setLogLevel(loglevel)
	end)

	modules.libraries.commands:create("purge",{},"purge gsave data",function(full_message, peer_id, is_admin, is_auth, command, ...)
		modules.libraries.gsave:_purgeGsave()
	end)
end)