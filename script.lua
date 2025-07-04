require "modules"

modules.onStart:once(function()
	modules.services.command:create("pinfo",{},"",function(player, full_message, command, args)
		modules.libraries.logging:debug("pinfo", "Command executed by peer_id: " .. tostring(player.peerId))
		if #args ~= 0 then
			local pid = tonumber(args[1])
			player = modules.services.player:getPlayerByPeer((pid and pid or -1))
		end
		modules.libraries.logging:info("pinfo", "Player info: " .. (player and player.steamId or "Nil") .. ", " .. (player and player.name or "Nil") .. ", " .. (player and tostring(player.inGame) or "Nil"))
	end)

	modules.services.command:create("loglevel",{"ll"}, "set the log level", function(player, full_message, command, args)
		if #args == 0 then
			modules.libraries.logging:warning("loglevel", "No log level provided")
			return
		end
		local loglevel = args[1]:upper()
		modules.libraries.logging:setLogLevel(loglevel)
	end)

	modules.services.command:create("purge",{},"purge gsave data",function(player, full_message, command, args)
		modules.libraries.gsave:_purgeGsave()
	end)

	modules.services.command:create("simjoin",{},"simulate a join",function(player, full_message, command, args)
		onPlayerJoin(1234567890, "Test<Player", 10, false, false)
	end)

	modules.services.command:create("simleave", {}, "simulate a leave", function(player, full_message, command, args)
		onPlayerLeave(1234567890, "Test<Player", 10, false, false)
	end)

	modules.services.command:create("players", {}, "get all players", function(player, full_message, command, args)
		local players = modules.services.player:getOnlinePlayers()
		local str = "Online Players:\n"
		for _, player in pairs(players) do
			str = str .. "SteamID: " .. player.steamId .. ", Name: " .. player.name .. ", PeerID: " .. player.peerId .. "\n"
		end
		modules.libraries.logging:info("players", str)
	end)

	modules.services.command:create("gettps", {}, "get tps", function(player, full_message, command, args)
		local tps = modules.services.tps:getTPS()
		modules.libraries.logging:info("tps", "Current TPS: " .. (tostring(tps) or "Nil"))
	end)

	modules.services.command:create("settps", {}, "set tps", function(player, full_message, command, args)
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

	modules.services.command:create("enableaddon", {}, "get all addons", function(player, full_message, command, args)
		if #args == 0 then
			modules.libraries.logging:warning("enableaddon", "No addon name provided")
			return
		end
		local addonName = args[1]
		modules.services.addon:enable(addonName)
	end)

	modules.services.command:create("disableaddon", {}, "disable an addon", function(player, full_message, command, args)
		if #args == 0 then
			modules.libraries.logging:warning("disableaddon", "No addon name provided")
			return
		end
		local addonName = args[1]
		modules.services.addon:disable(addonName)
	end)

	modules.services.command:create("loadaddons", {}, "load all addons", function(player, full_message, command, args)
		modules.services.addon:_loadAddons()
	end)

	modules.services.command:create("jsontest", {}, "test json library", function(player, full_message, command, args)
		local testTable = {
			name = "Test",
			value = 123,
			nested = {
				foo = "bar",
				baz = {1, 2, 3}
			}
		}
		local jsonString = modules.libraries.json:encode(testTable)
		modules.libraries.logging:info("jsontest", "Encoded JSON: " .. jsonString)

		local decodedTable = modules.libraries.json:decode(jsonString)
		modules.libraries.logging:info("jsontest", "Decoded Table: " .. modules.libraries.table:tostring(decodedTable))
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