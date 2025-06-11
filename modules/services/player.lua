modules.services.player = {}

modules.services.player.players = {} ---@type table<string, Player>

modules.libraries.callbacks:once("onCreate", function (is_world_create)
    modules.services.player:_load() -- load the player service on creation
end)

modules.libraries.callbacks:connect("onPlayerJoin", function(steam_id, name, peer_id, is_admin, is_auth)
    modules.libraries.logging:debug("onPlayerJoin", "Player joined with steam_id: " .. steam_id .. ", name: " .. name .. ", peer_id: " .. peer_id)
    local player = modules.services.player:getPlayer(steam_id)

    if not player then
        player = modules.classes.player:create(peer_id, steam_id, name, is_admin, is_auth)
        if not player then
            modules.libraries.logging:warning("services.player", "Failed to create player class: " .. steam_id)
            return
        end
    end

    modules.services.player.players[tostring(steam_id)] = player -- add the player to the table
    modules.services.player:_save() -- save the player service
end)

function modules.services.player:getPlayer(steam_id)
    if not steam_id then
        return nil
    end

    local player = self:getPlayers()[tostring(steam_id)]
    if not player then
        modules.libraries.logging:info("services.player:getPlayer", "Player not found with steam_id: " .. steam_id)
        return nil
    end

    return player -- return the player object
end

function modules.services.player:getPlayerByPeer(peer_id) -- not recommended to use this function, but it is here for compatibility
    for _, player in pairs(self:getPlayers()) do
        if player.peerId == tostring(peer_id) then
            return player -- return the player object if found
        end
    end
end

function modules.services.player:getPlayers()
    return self.players -- return the list of players
end

function modules.services.player:_load()
    local service = modules.libraries.gsave:loadService("player")
    if not service then
        modules.libraries.logging:warning("services.player:_load", "Skiped loading player service, no data found.")
        return
    end

    if service.players ~= nil then
        for _, playerData in pairs(service.players) do
            if not playerData or not playerData.steamId then
                modules.libraries.logging:warning("services.player:_load", "Skiped loading player data, no data")
                goto continue -- skip if playerData is nil or steamId is missing
            end
            if playerData.steamId == "0" then
                modules.libraries.logging:debug("services.player:_load", "Skiped loading player: "..playerData.name)
                goto continue -- skip players with steam_id 0
            end
            local player = modules.classes.player:create(
                playerData.peerId,
                playerData.steamId,
                playerData.name,
                playerData.admin,
                playerData.auth,
                playerData.perms,
                playerData.extra
            )
            if not player then
                modules.libraries.logging:warning("services.player:_load", "Failed to create player class for steam_id: " .. playerData.steam_id)
            else
                self.players[tostring(playerData.steamId)] = player -- add the player to the table
                modules.libraries.logging:debug("services.player:_load", "Loaded player: " .. player.name .. " with steam_id: " .. player.steamId)
            end
            ::continue::
        end
    end

    for _, player in pairs(server.getPlayers()) do
        if player.steam_id == 0 then
            modules.libraries.logging:debug("services.player:_load", "Skiped loading player: "..player.name)
            goto continue -- skip players with steam_id 0
        end
        local existingPlayer = self:getPlayer(player.steam_id)
        if not existingPlayer then
            local newPlayer = modules.classes.player:create(
                player.id,
                player.steam_id,
                player.name,
                player.admin,
                player.auth
            )
            if newPlayer then
                self.players[tostring(player.steam_id)] = newPlayer -- add the player to the table
                modules.libraries.logging:debug("services.player:_load", "Created player class for player: " .. newPlayer.name .. " with steam_id: " .. newPlayer.steamId)
                modules.services.player:_save() -- save the player service
            else
                modules.libraries.logging:warning("services.player:_load", "Failed to create player class for steam_id: " .. player.steam_id)
            end
        end
        ::continue::
    end
    modules.services.player:_save() -- save the player service after loading
end

function modules.services.player:_save()
    modules.libraries.gsave:saveService("player", self)
end