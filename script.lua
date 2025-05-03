require "modules"
--- Called when the script is initialized (whenever creating or loading a world.)
---@param is_world_create boolean Only returns true when the world is first created.
function onCreate(is_world_create)
	modules.main.libraries.logging:info("onCreate()", "Script loaded")
end

--- Called every game tick
---@param game_ticks number the number of ticks since the last onTick call (normally 1, while sleeping 400.)
function onTick(game_ticks)
	modules:Tick() -- run the tick function for all loaded addons
end

--- Called when the world is exited.
function onDestroy()
end