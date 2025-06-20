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
		local args = table.pack(...)
		modules.libraries.logging:debug("test command", "Command executed by peer_id: " .. tostring(peer_id))
		local player = modules.services.player:getPlayerByPeer(tonumber(args[1]) or peer_id)
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

	modules.libraries.commands:create("simjoin",{},"simulate a join",function(full_message, peer_id, is_admin, is_auth, command, ...)
		onPlayerJoin(1234567890, "TestPlayer", 10, false, false)
	end)

	modules.libraries.commands:create("simleave", {}, "simulate a leave", function(full_message, peer_id, is_admin, is_auth, command, ...)
		onPlayerLeave(1234567890, "TestPlayer", 10, false, false)
	end)
end)