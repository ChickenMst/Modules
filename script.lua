require "modules"

modules.onStart:once(function()
	modules.services.command:create("pinfo",{},"",function(full_message, peer_id, is_admin, is_auth, command, ...)
		local args = table.pack(...)
		modules.libraries.logging:debug("pinfo", "Command executed by peer_id: " .. tostring(peer_id))
		local player = modules.services.player:getPlayerByPeer(tonumber(args[1]) or peer_id)
		modules.libraries.logging:info("pinfo", "Player info: " .. (player and player.steamId or "Nil") .. ", " .. (player and player.name or "Nil") .. ", " .. (player and tostring(player.inGame) or "Nil"))
	end)

	modules.services.command:create("loglevel",{"ll"}, "set the log level", function(full_message, peer_id, is_admin, is_auth, command, ...)
		local args = {...}
		if #args == 0 then
			modules.libraries.logging:warning("loglevel", "No log level provided")
			return
		end
		local loglevel = args[1]:upper()
		modules.libraries.logging:setLogLevel(loglevel)
	end)

	modules.services.command:create("purge",{},"purge gsave data",function(full_message, peer_id, is_admin, is_auth, command, ...)
		modules.libraries.gsave:_purgeGsave()
	end)

	modules.services.command:create("simjoin",{},"simulate a join",function(full_message, peer_id, is_admin, is_auth, command, ...)
		onPlayerJoin(1234567890, "Test<Player", 10, false, false)
	end)

	modules.services.command:create("simleave", {}, "simulate a leave", function(full_message, peer_id, is_admin, is_auth, command, ...)
		onPlayerLeave(1234567890, "Test<Player", 10, false, false)
	end)

	modules.services.command:create("players", {}, "get all players", function(full_message, peer_id, is_admin, is_auth, command, ...)
		local players = modules.services.player:getOnlinePlayers()
		local str = "Online Players:\n"
		for _, player in pairs(players) do
			str = str .. "SteamID: " .. player.steamId .. ", Name: " .. player.name .. ", PeerID: " .. player.peerId .. "\n"
		end
		modules.libraries.logging:info("players", str)
	end)

	modules.services.command:create("gettps", {}, "get tps", function(full_message, peer_id, is_admin, is_auth, command, ...)
		local tps = modules.services.tps:getTPS()
		modules.libraries.logging:info("tps", "Current TPS: " .. (tostring(tps) or "Nil"))
	end)

	modules.services.command:create("settps", {}, "set tps", function(full_message, peer_id, is_admin, is_auth, command, ...)
		local args = {...}
		if #args == 0 then
			modules.libraries.logging:warning("settps", "No target TPS provided")
			return
		end
		local targetTPS = tonumber(args[1])
		if not targetTPS then
			modules.libraries.logging:warning("settps", "Invalid target TPS provided")
			return
		end
		modules.services.tps:setTPS(targetTPS)
		modules.libraries.logging:info("settps", "Target TPS set to: " .. tostring(targetTPS))
	end)

	modules.services.command:create("enableaddon", {}, "get all addons", function(full_message, peer_id, is_admin, is_auth, command, ...)
		local args = table.pack(...)
		if #args == 0 then
			modules.libraries.logging:warning("enableaddon", "No addon name provided")
			return
		end
		local addonName = args[1]
		modules.services.addon:enable(addonName)
	end)

	modules.services.command:create("disableaddon", {}, "disable an addon", function(full_message, peer_id, is_admin, is_auth, command, ...)
		local args = table.pack(...)
		if #args == 0 then
			modules.libraries.logging:warning("disableaddon", "No addon name provided")
			return
		end
		local addonName = args[1]
		modules.services.addon:disable(addonName)
	end)

	modules.services.command:create("loadaddons", {}, "load all addons", function(full_message, peer_id, is_admin, is_auth, command, ...)
		modules.services.addon:_loadAddons()
	end)
end)

modules.onStart:once(function()
	if modules.addonReason == "create" then
		modules.libraries.logging:info("onCreate()", "World created")
	elseif modules.addonReason == "reload" then
		modules.libraries.logging:info("onCreate()", "Script reloaded")
	elseif modules.addonReason == "load" then
		modules.libraries.logging:info("onCreate()", "World loaded")
	else
		modules.libraries.logging:info("onCreate()", "Unknown world state: " .. tostring(modules.addonReason))
	end
end)