# Modules
Modules is a framework for stormworks server addons (server scripts) that allows for more complex functions while keeping it easy to maintain and use. Modules does all the hard work like tracking players, vehicles etc so you can do things like:
```lua
modules.services.command:create("kick"--[[main command]],{"k"}--[[aliases]],{"mod","admin","owner"}--[[permissions to run the command]], "kick yourself"--[[description]],function(player--[[player class that ran the command]],fullMessage--[[full message string]],command--[[the actual command]],args--[[the arguments]],hasPerm--[[if the player has permission to use command]])
    if hasPerm then --[[check if the player has permission to run the command]]
        player:kick() --[[kicks the player who ran the command]]
    end
end)
```