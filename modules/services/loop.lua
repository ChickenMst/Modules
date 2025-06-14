modules.services.loop = {} -- table of loop functions

modules.services.loop.loops = {} -- table of loops

-- create a new loop
---@param time number
---@param func function
function modules.services.loop:create(time, func)
    local loop = modules.classes.loop:create(time, func, #modules.services.loop.loops)

    self.loops[loop.id] = loop
end

-- delete a loop
---@param id number
function modules.services.loop:remove(id)
    if self.loops[id] then
        self.loops[id] = nil
    end
end

-- connect into onTick
modules.libraries.callbacks:connect("onTick", function ()
    local timeNow = server.getTimeMillisec()
	for _, v in pairs(modules.services.loop.loops) do
		if timeNow >= v.creationTime + (v.time * 1000) and not v.paused then
			v.callback()
			v.creationTime = timeNow
		end
	end
end)