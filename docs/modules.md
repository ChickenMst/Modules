# Overview
Modules is a framework for stormworks server addons/scripts. Its purpose is to make it easier for people to make and maintain server addons by "doing all the hard work for you", in doing so it manages things like players and vehicles and puts them in easy to use classes and functions. Modules is made up of libraries, classes, and services. Classes are used to store data about things like a player or a vehicle and also provide functions to interact with the class. Libraries are "standalone" (besides the logging) groups of functions that either directly interact with the game or provide extra functionality, they do not store important things like class objects, they are generaly just functions. Services connect into things like game callbacks and provide functions to interact with it and the service itself, they can also store important info (generaly class objects).
## modules
The main modules table stores variables and events relating to modules itself and some info about the server or world. It does not have any functions in it besides internal ones to setup modules when it starts. Here are the variables it stores:
```lua
modules.isDedicated -- this boolean variable can be looked at after starting to see if the addon is being run on a dedicated server

modules.addonReason -- this variable can be looked at to see if the scripts where reloaded "reload", the world was created "create", or the world was loaded "load"
```
Here are the events that the main modules table has:
```lua
modules.onStart -- this event can be connected into so you can safely run code once modules has fully started

modules.onServiceInit -- this event can be connected into when all the services have initalised
```
## modules.classes
This table stores all the object builders for the classes. It in itself doesnt have any functions.
### modules.classes.widgets
This table stores all the UI widget builders. Like `modules.classes` it doesnt have any functions.
### modules.classes.widgets.popupScreen
This class is for the `PopupScreen` widget aswell as functions to interact with it. Although you can create an object directly from the class it is recomended to use the UI service `modules.services.ui:createPopupScreen()`.
```lua
---@param id integer -- the ui_id of the widget
---@param visable boolean -- if the PopupScreen widget is visable on the players screen
---@param text string -- the text for the PopupScreen widget
---@param x integer -- the x pos on the players screen. range from 1 to -1
---@param y integer -- the y pos on the players screen. range from 1 to -1
---@param player Player|nil -- the player class you would like to see the widget or nill for everyone
---@return ScreenWidget -- returns a class object
modules.classes.widgets.popupScreen:create(id, visable, text, x, y, player)
```
The class objects functions and variables:
```lua
popupScreen.id -- ui_id of the popup

popupScreen.player -- either player that the popup is assigned to or nil

popupScreen.visable -- if the popup is showing

popupScreen.text -- the text that is displayed on the popup

popupScreen.x -- x pos of the popup

popupScreen.y -- y pos of the popup

popupScreen:update() -- update the widget for the assigned player or all players

popupScreen:destroy() -- removes the widget for the assigned player or all players
```
Example usage for a single player:
```lua
local id = server.getMapID() -- get a ui_id to use for the popup

local player = modules.services.player:getPlayerByPeer(1) -- get the player with peer_id of 1

local popupScreen = modules.classes.widgets.popupScreen:create(id, true, "Welcome", 0, 0, player) -- create a popup for player with peer_id of 1 in the center of their screen that says "Welcome"

popupScreen:update() -- update the popup screen
```
Example usage for all players:
```lua
local id = server.getMapID() -- get a ui_id to use for the popup

local popupScreen = modules.classes.widgets.popupScreen:create(id, true, "Welcome All", 0, 0) -- create a popup for all players in the center of their screen that says "Welcome All"

popupScreen:update() -- update the popup screen
```
Example of updating variables:
```lua
local id = server.getMapID() -- get a ui_id to use for the popup

local popupScreen = modules.classes.widgets.popupScreen:create(id, true, "Welcome All", 0, 0) -- create a popup for all players in the center of their screen that says "Welcome All"

popupScreen:update() -- update the popup screen

popupScreen.text = "Well now thats different" --  change the text

popupScreen:update() -- update the popup screen. it now says "Well now thats different"
```
Example of destroying the popup:
```lua
local id = server.getMapID() -- get a ui_id to use for the popup

local popupScreen = modules.classes.widgets.popupScreen:create(id, true, "Welcome All", 0, 0) -- create a popup for all players in the center of their screen that says "Welcome All"

popupScreen:update() -- update the popup screen

popupScreen:destroy() -- removes popup screen from all players
```
## modules.classes.addon
This class is for addons to modules. addons can be dynamicly created, destroyed, enabled and disabled. They could provide extras like an antisteal etc to modules by just adding the script into the addons folder. For the addon to actually work it is recommended to use `modules.services.addon:createAddon()`.
```lua
---@param name string -- the name of the addon
---@param version string|number -- the version of the addon
---@param authors table<string> -- table of the addon authors
---@param description string -- a description of the addon
---@return Addon -- returns class object
modules.classes.addon:create(name, version, description, authors)
```
The class objects functions and variables:
```lua
addon.name -- name of the addon

addon.version -- version of the addon

addon.authors -- authors of the addon

addon.description -- description of the addon

addon.enabled -- if the addon is enabled. default is true

addon.connections -- table of event connections

addon.commands -- table of commands

addon.hasInit -- if the addon has been initalised

addon.hasStarted -- if the addon has been started

addon:enable() -- enables the addon

addon:disable() -- disables the addon

addon:addConnection() -- adds event connection into connections

addon:removeConnections() -- disconnects from all saved event connections

addon:addCommand() -- adds a command into commands

addon:removeCommands() -- removes all commands in commands
```
Example of a basic addon:
```lua
local addon = modules.classes.addon:create("test", 1, "test addon description", {"ChickenMst"}) -- remember that for the addon to work you need to use modules.services.addon:createAddon()

function addon:initAddon() -- this function is required even if you dont put anthing in it
    self.variable = 1 -- put any things that need to be made/got before the addon starts
end

function addon:startAddon() -- this function is required even if you don put anthing in it
    modules.libraries.logging:info("test addon", "this is my variable: "..self.variable) -- put things that you want to run in here, like connecting to a callback
end

function addon:help() -- make sure if your making extra functions in the addon to do it as addon:functionname() this allows for that function to be saved in the addon
    local help = nil
end
```
Example of adding a connection:
```lua
local addon = modules.classes.addon:create("test", 1, "test addon description", {"ChickenMst"}) -- remember that for the addon to work you need to use modules.services.addon:createAddon()

function addon:initAddon()
    self.variable = 1
end

function addon:startAddon()
    self:addConnection(modules.libraries.callbacks:connect("onTick", function(game_ticks) -- use the callbacks library wraped with self:addConnection() to add the connection. its best practice to do this so when the addon is disabled or removed it disconnects from all the connections
        modules.libraries.logging:info("test addon", "another tick has passed")
    end))
end
```
Example of adding a command:
```lua
local addon = modules.classes.addon:create("test", 1, "test addon description", {"ChickenMst"}) -- remember that for the addon to work you need to use modules.services.addon:createAddon()

function addon:initAddon()
    self.variable = 1
end

function addon:startAddon()
    self:addCommand(modules.services.command:create("test", {"t"}, {}, "test command", function(player, full_message, command, args, hasPerm) -- use the create command function wraped with self:addCommand() to add the command. its best practice to do this so when the addon is disabled or removed it removes all its commands
        modules.libraries.logging:info("test addon", "a player has run the test command")
    end))
end
```
Example of the addon disabling itself:
```lua
local addon = modules.classes.addon:create("test", 1, "test addon description", {"ChickenMst"}) -- remember that for the addon to work you need to use modules.services.addon:createAddon()

function addon:initAddon()
    self.variable = 1
end

function addon:startAddon()
    if self.variable == 1 then -- addon may have failed to start. disable it so it dosnt cause any problems
        self:disable()
    end
end
```
## modules.classes.command
This class is for the custom command handling via `modules.services.command`. It allows for an easy way to make commands with aliases, permisions and more. This class is mostly info, and requires to be made via `modules.services.command:create()` to work.
```lua
---@param commandstr string -- the string that for the main command, can be with or without ?
---@param alias table<string> -- table of alias strings for the command
---@param perms table<string> -- table of permissions required to run the command
---@param description string -- a description of the command
---@param func function -- the function to be run when the command is called
---@return Command -- returns class object
modules.classes.command:create(commandstr, alias, perms, description, func)
```
The class objects functions and variables:
```lua
command.commandstr -- the main command string

command.alias -- table of aliases for the command

command.perms -- table of permissions required to run the command

command.description -- the description of the command

command.func -- the function that is run whe the command is called

command.enabled --  if the command is enabled. default is true

command:enable() -- enables the command

command:disable() -- disables the command so it cant be run

---@param player Player -- player that ran the command
---@param full_message string -- the full command message
---@param command string -- the command that was used to run the command
---@param args table -- table of arguments for the command
---@param hasPerm boolean -- if the player has one of the permissions
command:run(player, full_message, command, args, hasPerm) -- used by modules.services.command to run func when the command is called. func must use these parameters
```
Example of a basic command:
```lua
modules.classes.command:create("test", {} , {} , "test command", function(player, full_message, command, args, hasPerm) -- create a command with no perms or aliases. remember to use modules.services.command:create() to create the command
    modules.libraries.logging:info("test command", "the command was run")
end)
```
Example of a command with permissions:
```lua
modules.classes.command:create("permcheck",{},{"perm"}, "check if player has permission", function(player, full_message, command, args, hasPerm) -- requires the player to have the permission "perm". remember to use modules.services.command:create() to create the command
    if not hasPerm then -- if the player has one of the permitions this would be true
        modules.libraries.logging:info("permcheck", "Player does not have permission to run this command")
    else
        modules.libraries.logging:info("permcheck", "Player does not have permission to run this command")
    end
end)
```
Example of a command with aliases:
```lua
modules.classes.command:create("aliastest", {"a","at","alias"}, {}, "show the alias that the command was run by", function(player, full_message, command, args, hasPerm) -- create a command with the aliases "a","at","alias". remember to use modules.services.command:create() to create the command
    modules.libraries.logging:info("aliastest command", "the command was run by: "..command) -- prints the alias or command the command was called by
end)
```
## modules.classes.connection
This class is a helper class for event class. It represents a connection (function connected to the event) allowing for connections to be disconnected from an event at any time. because of this you will never need to create a connection object yourself.
```lua
---@param callback function -- the function to be run when the connection is fired
---@return EventConnection -- returns class object
modules.classes.connection:create(callback)
```
The class objects functions and variables:
```lua
connection.callback -- to be run when the connection it fired

connection.parentEvent -- the parent event that the connection is for

connection.connected --  if the connection is connected to and event

connection.id -- id of the connection. given to it by the event

connection.index -- index for connections order in event

connection:fire(...) -- calls the function and passes through the parameters from the event

connection:disconnect() -- disconnects the connection from the parent event
```
## modules.classes.event
This class allow for events. Functions can be connected to it by turning them into connections then be ran when the event is fired.
```lua
---@return Event -- return class object
modules.classes.event:create()
```
The class objects functions and variables:
```lua
event.currentId -- used for connection ids

event.connections -- table of connected connections

event.connectionsOrder -- table of the order that the connections where connected

event.connectionsToRemove -- table of connection to be removed from the event

event.connectionsToAdd -- table of connections to be added to the event

event.isFireing -- boolean to tell if the event is currently being fired

event.hasFiredOnce -- used for event:once() to tell if the event has already fired

---@param callback function -- the function to be turned into a connection and added to the event
---@return EventConnection
event:connect(callback) -- connect a function to the event

---@param callback function -- the function to be turned into a connection and added to the event
---@return EventConnection
event:once(callback) -- connect a function to the event but once its fired disconnect it

---@param connection EventConnection -- the connection to remove from the event
event:disconnect(connection) -- remove connection from the event

event:fire(...) -- fire the event and pass through the arguments
```
Example basic usage:
```lua
local event = modules.classes.event:create() -- create the event

event:connect(function() -- connect to the event
    modules.libraries.logging:info("event", "event has fired")
end)

event:once(function()
    modules.libraries.logging:info("event", "event has fired once") --  this will only show one time even if the event is fired more than one time
end)

event:fire() -- fire the event
```
Example of disconnecting:
```lua
local event = modules.classes.event:create() -- create the event

local connection = event:connect(function() -- connect to the event
    modules.libraries.logging:info("event", "event has fired")
end)

event:fire() -- fire the event

-- you can use either this to disconnect from the event
connection:disconnect()

-- or this to disconnect from the event
event:disconnect(connection)
```
## modules.classes.httpRequest
This class is used by `modules.services.http` to represent a http request to the backend.
```lua
---@param request string -- request or url for the http request
---@param port number -- port for the http request
---@param id number -- id is used when there is a reply
---@param func fun(request:HttpRequest, reply: any) | nil -- function to be called when there is a reply
---@return HttpRequest -- returns class object
modules.classes.httpRequest:create(request, port, id, func)
```
The class objects functions and variables:
```lua
httpRequest.request -- the url of the http request you are making

httpRequest.port -- the port to send the request on

httpRequest.id -- request id is given by modules.services.http

httpRequest.func -- function to be called when the http request gets its reply
```