---@class tpsService: Service
---@field targetTPS number -- target TPS (ticks per second)
---@field tps number -- current TPS (ticks per second)
---@field _last number -- last tick time in milliseconds
modules.services.tps = modules.services:createService("tps", "Service for calculating and managing tps", {"ChickenMst"})

function modules.services.tps:initService()
    self.targetTPS = 0 -- target TPS (ticks per second)
    self.tps = 0 -- current TPS (ticks per second)
    self._last = server.getTimeMillisec() -- last tick time in milliseconds
end

function modules.services.tps:startService()
    modules.libraries.callbacks:connect("onTick", function (game_ticks)
        local now = server.getTimeMillisec()

        if self.targetTPS ~= 0 then
            while self:_calculateTPS(self._last, now, game_ticks) > self.targetTPS do
                now = server.getTimeMillisec() -- update the current time
            end
        end

        self.tps = self:_calculateTPS(modules.services.tps._last, now, game_ticks)
        self._last = server.getTimeMillisec() -- update the last tick time
    end)
end

function modules.services.tps:_calculateTPS(last, now, ticks)
    return 1000 / (now - last) * ticks
end

function modules.services.tps:getTPS()
    return self.tps
end

function modules.services.tps:setTPS(targetTPS)
    if targetTPS < 0 then
        targetTPS = 0 -- disable TPS limiting if targetTPS is negative
    end

    self.targetTPS = targetTPS -- set the target TPS
end