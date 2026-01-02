# Modules

Modules is a framework for stormworks server addons (server scripts) that allows for more complex functions while keeping it easy to maintain and use. Modules does all the hard work like tracking players, vehicles and more so you can easily do things like:

```lua
modules.services.command:create("kick", {"k"}, {"mod", "admin", "owner"}, "kick yourself", function(player, fullMessage, command, args, hasPerm)
    if hasPerm then -- check if the player has permission to run the command
        player:kick() --kicks the player who ran the command
    end
end)
```

## Installation

Adding Modules to your addon is a simple as dragging the contents of a release into your project directory and adding `require "modules"` at the top of your `script.lua`, you now have acsess to modules and all of its features.

To build the script you will need to install and setup [`ssswtool`](https://github.com/Avril112113/SSSWTool). You can find an explaination of how to use [`ssswtool`](https://github.com/Avril112113/SSSWTool) in their repo.

## Documentation

The documentation for Modules goes over all of its functions, values, etc. It can be found [here](docs/modules.md).
