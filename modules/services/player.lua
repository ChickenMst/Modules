modules.services.player = modules.services:createService("player", "Handles player data and events", {"ChickenMst"})

function modules.services.player:initService()
    self.onJoin = modules.libraries.events:create()
    self.onLeave = modules.libraries.events:create()

    self.players = {} ---@type table<string, Player>
end


function modules.services.player:startService()
    if modules.addonReason == "reload" then
        self:_load() -- load the player service on creationTime
    end

    modules.libraries.callbacks:connect("onPlayerJoin", function(steam_id, name, peer_id, is_admin, is_auth)
        name = self:_cleanName(name)
        modules.libraries.logging:debug("onPlayerJoin", "Player joined with steam_id: " .. steam_id .. ", name: " .. name .. ", peer_id: " .. peer_id)
        local player = self:getPlayer(tostring(steam_id))

        if not player then
            player = modules.classes.player:create(peer_id, steam_id, name, is_admin, is_auth)
            if not player then
                modules.libraries.logging:warning("services.player", "Failed to create player class: " .. steam_id)
                return
            end
        end

        player.inGame = true -- set the player as in-game
        self.players[tostring(steam_id)] = player -- add the player to the table
        self:_save() -- save the player service
        self.onJoin:fire(player) -- fire the event
    end)

    modules.libraries.callbacks:connect("onPlayerLeave", function(steam_id, name, peer_id, is_admin, is_auth)
        -- skip if steam_id is nil or 0
        if not steam_id or steam_id == 0 then
            return
        end

        name = self:_cleanName(name)

        modules.libraries.logging:debug("onPlayerLeave", "Player left with steam_id: " .. (steam_id or "unknown") .. ", name: " .. name .. ", peer_id: " .. peer_id)
        local player = self:getPlayer(tostring(steam_id))

        if player then
            player.inGame = false -- set the player as not in-game
            self.onLeave:fire(player) -- fire the event
            self.players[tostring(steam_id)] = player
            self:_save() -- save the player service
        end
    end)
end

---@param steam_id string
---@return Player|nil
function modules.services.player:getPlayer(steam_id)
    for _,player in pairs(self:getPlayers()) do
        modules.libraries.logging:debug("services.player:getPlayer", "Checking player with steam_id: " .. player.steamId)
        if player.steamId == tostring(steam_id) then
            modules.libraries.logging:debug("services.player:getPlayer", "Found player: " .. player.name .. " from steam_id: " .. player.steamId)
            return player -- return the player object if found
        end
    end
    modules.libraries.logging:info("services.player:getPlayer", "Player not found with steam_id: " .. steam_id)
end

---@param peer_id number
---@return Player|nil
function modules.services.player:getPlayerByPeer(peer_id) -- not recommended to use this function, but it is here for compatibility
    for _, player in pairs(self:getPlayers()) do
        modules.libraries.logging:debug("services.player:getPlayerByPeer", "Checking player with peer_id: " .. player.peerId)
        if player.peerId == peer_id then
            modules.libraries.logging:debug("services.player:getPlayerByPeer", "Found player: " .. player.name .. " from peer_id: " .. player.peerId)
            return player -- return the player object if found
        end
    end
end

---@return table<string, Player>
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
        local existingPlayer = self:getPlayer(tostring(player.steam_id))
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

function modules.services.player:_cleanName(name)
    return string.gsub(name, "[<]", "")
end