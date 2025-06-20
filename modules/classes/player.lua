modules.classes.player = {} -- table of player functions

---@param peerId number
---@param steamId string|number
---@param name string|nil
---@param admin boolean|nil
---@param auth boolean|nil
---@param perms table|nil
---@param extra table|nil
---@return Player
function modules.classes.player:create(peerId, steamId, name, admin, auth, perms, extra)
    ---@class Player
    local player = {
        peerId = math.floor(peerId),
        steamId = tostring(steamId),
        name = name or "Unknown",
        admin = admin or false,
        auth = auth or false,
        inGame = true,
        perms = perms or {},
        extra = extra or {}
    }

    function player:setName(newName)
        self.name = newName
    end

    function player:setAdmin(isAdmin)
        self.admin = isAdmin
        if isAdmin then
            server.addAdmin(self.peerId)
        else
            server.removeAdmin(self.peerId)
        end
    end

    function player:setAuth(isAuth)
        self.auth = isAuth
        if isAuth then
            server.addAuth(self.peerId)
        else
            server.removeAuth(self.peerId)
        end
    end

    function player:setExtra(key, value)
        if not self.extra then
            self.extra = {}
        end
        self.extra[key] = value
    end

    function player:getExtra(key)
        if not self.extra then
            return nil
        end
        return self.extra[key]
    end

    function player:setPerm(perm, value)
        self.perms[perm] = value
    end

    function player:hasPerm(perm)
        return self.perms[perm] ~= nil
    end

    function player:getPerms()
        return self.perms
    end

    function player:removePerm(perm)
        if self.perms[perm] then
            self.perms[perm] = nil
        end
    end

    return player
end