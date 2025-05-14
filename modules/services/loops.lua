modules.services.loops = {} -- table of loop functions

modules.services.loops.loops = {} -- table of loops

-- create a new loop
---@param time number
---@param func function
function modules.services.loops:create(time, func)
    local loop = modules.classes.loop:create(time, func, #modules.services.loops.loops)

    self.loops[loop.id] = loop
end

-- delete a loop
---@param id number
function modules.services.loops:remove(id)
    if self.loops[id] then
        self.loops[id] = nil
    end
end

-- connect into onTick
modules.libraries.callbacks:connect("onTick", function ()
    local timeNow = server.getTimeMillisec()
	for _, v in pairs(modules.services.loops.loops) do
		if timeNow >= v.creationTime + (v.time * 1000) and not v.paused then
			v.callback(v.id)
			v.creationTime = timeNow
		end
	end
end)