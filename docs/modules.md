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
### modules.classes.addon
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
### modules.classes.command
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
### modules.classes.connection
This class is a helper class for event class. It represents a connection (function connected to the event) allowing for connections to be disconnected from an event at any time. Because of this you will never need to create a connection object yourself.
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
### modules.classes.event
This class allow for events. Functions can beections work events and connecti connected to it by turning them into connections then be ran when the event is fired. Due to the way connections cant be saved into gsave.
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
### modules.classes.httpRequest
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
### modules.classes.loop
This class by `modules.services.loop` to make the loop objects. It runs the function given to it every time the inputed time has passed. This will more thank likely be replaced by something better. For it to work it needs to be made with `modules.services.loop:create()`
```lua
---@param time number -- how often it runs in seconds
---@param func function -- the function to be ran
---@param id number -- id given to it by modules.services.loop
---@return Loop -- returns class object
modules.classes.loop:create(time, func, id)
```
The class objects functions and variables:
```lua
loop.callback -- function to be ran

loop.time -- in seconds how often it runs

loop.creationTime -- the time at which it was made

loop.id -- the id of the loop

loop.paused -- boolean if the loop is paused

---@param state boolean -- if its paused or not
loop:setPaused(state) -- set the state of paused

---@param newTime number -- the new time period
loop:editTime(newTime) -- change the time period
```
Example usage:
```lua
local loop = modules.classes.loop:create(1, function() -- create a loop that runs every second. remember to use modules.services.loop:create() or it won't work
    modules.libraries.logging:info("loop", "1 second has passed")
end, 1)
```
Example of pausing and updating the time period:
```lua
local loop = modules.classes.loop:create(1, function() -- create a loop that runs every second. remember to use modules.services.loop:create() or it won't work
    modules.libraries.logging:info("loop", "1 second has passed")
end, 1)

loop:setPaused(true) -- pause the loop

loop:editTime(2) -- change the time period of the loop

loop:setPaused(false) -- unpause the loop
```
### modules.classes.player
This class represents a stormworks player. It made by `modules.services.player` when a player joins or a player dosnt have a class for it. You will not need to manually create this for a player as `modules.services.player` handles all of that.
```lua
---@param peerId number -- players peer_id
---@param steamId string|number -- players steam_id
---@param name string|nil -- players name
---@param admin boolean|nil -- if the player is a server admin
---@param auth boolean|nil -- if the player is authed
---@param perms table|nil -- table of permissions for the player
---@param extra table|nil -- emtpy table for any extra data you need to add to the player
---@return Player -- returns class object
modules.classes.player:create(peerId, steamId, name, admin, auth, perms, extra)
```
The class objects functions and variables:
```lua
player.peerId -- players peer_id

player.steamId -- players steam_id

player.name -- players name

player.admin -- boolean if the player has server admin

player.auth -- boolean if the player is authed

player.inGame -- boolean if the player is currently in game / on the server

player.perms -- table of the players permissions

player.extra -- table that can be used to store extra info/data about the player

---@param newName string -- the new name you want to set to
player:setName(newName) -- set the players name

---@param isAdmin boolean -- if you want the player to have admin or not
player:setAdmin(isAdmin) -- set the players admin status to isAdmin

---@param isAuth boolean -- if you want to auth the player
player:setAuth(isAuth) -- set the players auth status to isAuth

---@param key string|number -- key / index of the thing you want to set
---@param value any -- what you want to set it to
player:setExtra(key, value) -- set a extra value for the player

---@param key string|number -- key / index of the extra you want to get
player:getExtra(key) -- get the value of the inputed key

---@param perm string -- the permission you want to change
---@param value boolean|nil -- the value you want to set it to
player:setPerm(perm, value) -- set a perm to the inputed value

---@param perm string -- the permission you want to check for
---@param valueToMatch any|nil -- the value it has to match if it exists
---@return boolean -- if it exists and or if it matches the value to match
player:hasPerm(perm, valueToMatch) -- check if the player has a specific permission

---@return table -- the player permissions
player:getPerms() -- return the players perm table

---@param perm string -- the permission to remove
player:removePerm(perm) -- removes the permission from the player

player:kick() -- kicks the player from the server

player:ban() -- bans the player from the server

player:kill() -- kills the players character

player:revive() -- revives the players character

---@param pos table -- matrix table
player:teleport(pos) -- teleports player to the inputed matrix

---@return table -- matrix table
player:getPos() -- returns the players position as matrix
```
### modules.classes.service
This class represents a service in `modules`. allows for the service to be initalised and then started. must be called via `modules.services:createService()` to be initalised and started automaticly by modules.
```lua
---@param name string -- name of the service
---@param description string -- a description of the servoce
---@param authors table<string> -- table of the services authors
---@return Service -- returns class object
modules.classes.service:create(name, description, authors)
```
The class objects functions and variables:
```lua
service.name -- name of the service

service.description -- description of the service

service.authors -- table of the services authors

service.hasInit -- boolean if the service has been initalised

service.hasStarted -- boolean if the service has been started
```
Example usage:
```lua
service = modules.classes.service:create("service", "its a service", {"ChickenMst"}) -- create the service. remember to use modules.services:createService()

function service:initService() -- required even if its empty
    self.value = 21 -- put any values etc that you need to get / create before the service starts
end

function service:startService() -- required even if its empty
    modules.libraries.logging:info("service", "i has started, here is my value: "..self.value)
end

function service:changeValue() -- useing the format servicename:function() allows for the function to be saved into the service. this is the recommended way
    self.value = self.value + 1 
end
```
### modules.classes.vehicle
This class represnts a stormworks vehicle. It is use along with `modules.classes.vehicleGroup` to manage the vehicles. You will not need to create an object of this class, you can get the vehicles group by using `modules.services.vehicle:getVehicleGroup()`.
```lua
---@param vehicleId number -- the vehicles vehicle_id
---@param groupId number|string -- the vehicles group_id
---@param loaded boolean|nil -- if the vehicle has been loaded yet
---@return Vehicle -- returns a class object
modules.classes.vehicle:create(vehicleId, groupId, loaded)
```
The class objects functions and variables:
```lua
vehicle.id -- the vehicles vehicle_id

vehicle.groupId -- the vehicles group_id

vehicle.onDespawn -- event for when the vehicle is despawned

vehicle.onLoaded -- event for when the vehicle has been loaded

vehicle.isLoaded -- if the vehicle is loaded or not

vehicle.isDespawned -- if the vehicle has bene despawned

vehicle:despawned() -- function modules.services.vehicle calls when the vehicle gets despawned

vehicle:loaded() -- function modules.services.vehicle calls when the vehicle is loaded
```
### modules.classes.vehicleGroup
This class represents a stormworks vehicle group. It is use along with `modules.classes.vehicle` to manage the vehicles. You will not need to create an object of this class, you can get the vehicle group by using `modules.services.vehicle:getVehicleGroup()`.
```lua
---@param group_id number|string -- group_id of the vehicle group
---@param owner Player|nil -- the player that owns the vehicle group
---@param spawnTime number|nil -- when the vehicle group was spawned
---@param loaded boolean|nil -- if the vehicle group is loaded
---@return VehicleGroup -- returns class object
modules.classes.vehicleGroup:create(group_id, owner, spawnTime, loaded)
```
The class objects functions and variables:
```lua
vehicleGroup.groupId -- vehicle groups group_id

vehicleGroup.vehicles -- table of vehicles part of the vehicle group

vehicleGroup.owner -- player that owns the vehicle group

vehicleGroup.spawnTime -- time the vehicle was spawned

vehicleGroup.onDespawn -- event for when the vehicle group is despawned

vehicleGroup.onLoaded -- event for when the vehicle group is loaded

vehicleGroup.isLoaded -- if the vehicle group is loaded

vehicleGroup:despawned() -- function modules.services.vehicle calls when the vehicle group is despawned

vehicleGroup:loaded() -- function modules.services.vehicle calls when the vehicle group is loaded

---@param newowner Player -- the new player you want to own the vehicle group
vehicleGroup:setOwner(newowner) -- set the new owner for the vehicle group

---@param vehicle Vehicle -- vehicle you want to add to the vehicle group
vehicleGroup:addVehicle(vehicle) -- add a vehicle to the vehicle group
```
## modules.libraries
This table stores all the libraries. It in itself doesnt have any functions.
### modules.libraries.callbacks
This library uses events and `_ENV` to allow for functions to be dynamicly connected and disconnected from stormworks game callbacks. use this library instead of the traditional way of using stormworks game callbacks.
```lua
---@param name string -- the name of the callback you want to connect to eg: "onPlayerJoin"
---@param callback function -- the function you want to get run when the callback is called
---@return EventConnection -- returns the events connection. meaning you can disconnect etc like an event
modules.libraries.callbacks:connect(name, callback) -- connects your function into specified callback

---@param name string -- the name of the callback you want to connect to eg: "onPlayerJoin"
---@param callback function -- the function you want to get run when the callback is called
---@return EventConnection -- returns the events connection. meaning you can disconnect etc like an event
modules.libraries.callbacks:once(name, callback) -- connects your function into specified callback then disconnects once it has fired
```
Example `connect()` usage:
```lua
modules.libraries.callbacks:connect("onPlayerJoin", function(steam_id, name, peer_id, is_admin, is_auth) -- connect into the onPlayerJoin callback
    modules.libraries.logging:info("callback", "player "..name.." has joined!") -- info message when a player joins
end)
```
Example `once()` usage:
```lua
modules.libraries.callbacks:once("onTick", function(game_ticks) -- connect once into onTick callback
    modules.libraries.logging:info("callback", "the game has ticked. i will not run again") -- info message will only be printed once event if callback is called again
end)
```
Example of using connections:
```lua
local connection = modules.libraries.callbacks:connect("onTick", function(game_ticks) -- connect into the callback
    modules.libraries.logging:info("callback", "game has ticked") -- info message
end)

connection:disconnect() -- disconnect from the callback
```
### modules.libraries.chat
This library interacts with the games chat. It also saves all the announcements that have been sent.
```lua
modules.libraries.chat.messages -- table of announcments

---@param title string -- the title of the announcement
---@param message string -- the message of the announcement
---@param target number|nil -- the target player peer_id, nil or -1 for all players
modules.libraries.chat:announce(title, message, target) -- send announcment into the chat
```
Example `announce()` usage:
```lua
modules.libraries.chat:announce("[Server]", "this shows in chat to all players!")

modules.libraries.chat:announce("[Server]", "so does this!", -1)

modules.libraries.chat:announce("[Server]", "this only shows to player with the peer_id of 10", 10)
```
### modules.libraries.event
This library is used to make events and also provides `modules.libraries.event.removeConnection`. You dont need to use this as its just another step to call `modules.classes.event:create()`.
```lua
modules.libraries.event.removeConnection -- empty table used for disconnecting from an event inside of the function

modules.libraries.event:create() -- just a relay for `modules.classes.event:create()`
```
Example `removeConnection` usage:
```lua
event:connect(function(worked) -- connect into an event
    if worked then
        modules.libraries.logging:info("event", "the thing worked, disconnecting")
        return modules.libraries.event.removeConnection -- return this to tell the event to remove this connection
    else
        modules.libraries.logging:info("event", "the thing didnt work, staying connected")
    end
end)
```
### modules.libraries.gsave
This library handles the interactions with `g_savedata`.
```lua
---@param name string -- name of the service you want to save
---@param service any -- the service you want to save
modules.libraries.gsave:saveService(name, service) -- save a service into gsave. striped of functions and events before its saved

---@param name string -- name of the service you want to load
---@return Service|table -- the service loaded from g_savedata, or an empty table if not found
modules.libraries.gsave:loadService(name) -- load a service from gsave. handling of loading it back into the service is up to you
```