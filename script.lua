require "modules"

modules.onStart:once(function()
	modules.services.command:create("pinfo",{},{},"",function(player, full_message, command, args, hasPerm)
		modules.libraries.logging:debug("pinfo", "Command executed by peer_id: " .. tostring(player.peerId))
		if #args ~= 0 then
			local pid = tonumber(args[1])
			player = modules.services.player:getPlayerByPeer((pid and pid or -1))
		end
		modules.libraries.logging:info("pinfo", "Player info: " .. (player and player.steamId or "Nil") .. ", " .. (player and player.name or "Nil") .. ", " .. (player and tostring(player.inGame) or "Nil"))
	end)

	modules.services.command:create("loglevel",{"ll"}, {}, "set the log level", function(player, full_message, command, args, hasPerm)
		if #args == 0 then
			modules.libraries.logging:warning("loglevel", "No log level provided")
			return
		end
		local loglevel = args[1]:upper()
		modules.libraries.logging:setLogLevel(loglevel)
	end)

	modules.services.command:create("purge",{}, {},"purge gsave data",function(player, full_message, command, args, hasPerm)
		modules.libraries.gsave:_purgeGsave()
	end)

	modules.services.command:create("simjoin",{}, {},"simulate a join",function(player, full_message, command, args, hasPerm)
		onPlayerJoin(1234567890, "Test<Player", 10, false, false)
	end)

	modules.services.command:create("simleave", {}, {}, "simulate a leave", function(player, full_message, command, args, hasPerm)
		onPlayerLeave(1234567890, "Test<Player", 10, false, false)
	end)

	modules.services.command:create("players", {}, {}, "get all players", function(player, full_message, command, args, hasPerm)
		local players = modules.services.player:getOnlinePlayers()
		local str = "Online Players:\n"
		for _, player in pairs(players) do
			str = str .. "SteamID: " .. player.steamId .. ", Name: " .. player.name .. ", PeerID: " .. player.peerId .. "\n"
		end
		modules.libraries.logging:info("players", str)
	end)

	modules.services.command:create("gettps", {}, {}, "get tps", function(player, full_message, command, args, hasPerm)
		local tps = modules.services.tps:getTPS()
		modules.libraries.logging:info("tps", "Current TPS: " .. (tostring(tps) or "Nil"))
	end)

	modules.services.command:create("settps", {}, {}, "set tps", function(player, full_message, command, args, hasPerm)
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

	modules.services.command:create("enableaddon", {}, {}, "get all addons", function(player, full_message, command, args, hasPerm)
		if #args == 0 then
			modules.libraries.logging:warning("enableaddon", "No addon name provided")
			return
		end
		local addonName = args[1]
		modules.services.addon:enable(addonName)
	end)

	modules.services.command:create("disableaddon", {}, {}, "disable an addon", function(player, full_message, command, args, hasPerm)
		if #args == 0 then
			modules.libraries.logging:warning("disableaddon", "No addon name provided")
			return
		end
		local addonName = args[1]
		modules.services.addon:disable(addonName)
	end)

	modules.services.command:create("loadaddons", {}, {}, "load all addons", function(player, full_message, command, args, hasPerm)
		modules.services.addon:_loadAddons()
	end)

	modules.services.command:create("permcheck",{},{"perm"}, "check if player has permission", function(player, full_message, command, args, hasPerm)
		if not hasPerm then
			modules.libraries.logging:warning("permcheck", "Player does not have permission to run this command")
			return
		end
	end)

	modules.services.command:create("permset",{},{},"set permission for player", function(player, full_message, command, args, hasPerm)
		local perm = args[1]
		player:setPerm(perm, true)
		modules.libraries.logging:info("permset", "Permission " .. perm .. " set for player " .. player.name)
	end)

	modules.services.command:create("httptest", {}, {}, "test HTTP service", function(player, full_message, command, args, hasPerm)
		modules.services.http:get("http://localhost:8080/api/server/301/?action=kill", function(request, reply)
			if type(reply) == "table" then
				modules.libraries.logging:debug("httptest", "Received reply: " .. modules.libraries.table:tostring(reply))
			else
				modules.libraries.logging:error("httptest", "No reply received")
			end
		end, true)
		modules.services.http:get("http://localhost:8080/api/server/30/?action=kill", function(request, reply)
			if type(reply) == "table" then
				modules.libraries.logging:debug("httptest", "Received reply: " .. modules.libraries.table:tostring(reply))
			else
				modules.libraries.logging:error("httptest", "No reply received")
			end
		end, true)
	end)

	modules.services.command:create("ui", {}, {}, "test command", function (player, full_message, command, args, hasPerm)
		if args[1] == "clear" then
			local widgets = modules.services.ui:getPlayersShownWidgets(player)
			for _, widget in pairs(widgets) do
				widget:destroy()
				modules.services.ui:removeWidget(widget.id)
			end
			return
		elseif args[1] == "list" then
			local widgets = modules.services.ui:getPlayersShownWidgets(player)
			local str = "Widgets:\n"
			for _, widget in pairs(widgets) do
				str = str .. "ID: " .. widget.id .. ", Type: " .. widget.type .. ", Player: " .. (widget.player and widget.player.name or "Nil") .. "\n"
			end
			modules.libraries.logging:info("ui", str)
			return
		elseif args[1] == "create" then
			modules.services.ui:createMapObject(args[2], args[3], modules.classes.widgets.color:create(100,100,100,255), 1, 0, 1000, 1000, args[4], player)
		end
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