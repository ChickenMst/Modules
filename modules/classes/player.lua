modules.classes.player = {} -- table of player functions

function modules.classes.player:create(peerId, steamId, name, admin, auth, perms)
    ---@class Player
    local player = {
        peerId = peerId,
        steamId = steamId,
        name = name or "Unknown",
        admin = admin or false,
        auth = auth or false,
        perms = perms or {},
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
end