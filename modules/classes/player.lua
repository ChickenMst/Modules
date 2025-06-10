modules.classes.player = {} -- table of player functions

---@param peerId string|number
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
        peerId = tostring(peerId),
        steamId = tostring(steamId),
        name = name or "Unknown",
        admin = admin or false,
        auth = auth or false,
        perms = perms or {},
        extra = extra or {}
    }

    function player:setName(newName)
        self.name = newName
    end

    function player:setAdmin(isAdmin)
        self.admin = isAdmin
    end

    function player:setAuth(isAuth)
        self.auth = isAuth
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
        self.perms[perm] = value or true
    end

    function player:hasPerm(perm)
        return self.perms[perm] or false
    end

    function player:removePerm(perm)
        if self.perms[perm] then
            self.perms[perm] = nil
        end
    end

    return player
end