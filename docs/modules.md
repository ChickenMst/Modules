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

### modules.classes.widgets.color

This class is represents the `r,g,b,a` used in creation of classes like `MapObject`, allowing for easy repeat use of a color.

```lua
---@param r number|nil -- the red value (0-255) defaults to 255
---@param g number|nil -- the green value (0-255) defaults to 255
---@param b number|nil -- the blue value (0-255) defaults to 255
---@param a number|nil -- the alpha value (0-255) defaults to 255
---@return Color
modules.classes.widgets.color:create(r, g, b, a)
```

The class objects functions and variables:

```lua
color.r -- the red value (0-255)

color.g -- the green value (0-255)

color.b -- the blue value (0-255)

color.a -- the alpha value (0-255)
```

### modules.classes.widgets.mapLabel

This class is for the `MapLabel` widget aswell as functions to interact with it. Although you can create an object directly from the class it is recomended to use the UI service `modules.services.ui:createMapLabel()`.

```lua
---@param id integer -- the ui_id of the widget
---@param text string -- the text on the MapLabel
---@param labelType integer -- the labels type (0-20)
---@param x number -- the x pos on the map
---@param z number -- the z pos on the map
---@param player Player|nil -- the player class you would like to see the widget or nil for everyone
---@param name string|nil -- the name of the widget (useful when trying to find widget)
---@return MapLabelWidget -- returns class object
modules.classes.widgets.mapLabel:create(id, text, labelType, x, z, player, name)
```

The class objects functions and variables:

```lua
mapLabel.id -- ui_id of the widget

mapLabel.type -- the widgets type, can be used to filter for a specific type of widget

mapLabel.playerId -- either players steamId that the popup is assigned to or nil

mapLabel.text -- the text on the MapLabel

mapLabel.labelType -- the MapLabels type

mapLabel.x -- x pos of the MapLabel

mapLabel.z -- y pos of the MapLabel

mapLabel.name -- the name of the widget

mapLabel:update() -- update the widget for the assigned player or all players

mapLabel:destroy() -- removes the widget for the assigned player or all players

mapLabel:save() -- save the widget into the ui service
```

Example usage is the same as `PopupScreen` class.

### modules.classes.widgets.mapObject

This class is for the `MapObject` widget aswell as functions to interact with it. Although you can create an object directly from the class it is recomended to use the UI service `modules.services.ui:createMapObject()`.

```lua
---@param id integer -- the ui_id of the widget
---@param label string -- the label of the MapObject
---@param hoverLabel string -- the label when hovered over the MapObject
---@param color Color -- the color of the MapObject
---@param posType integer -- the pos type (0-2)
---@param markerType integer -- the type of marker for the MapObject (0-19)
---@param x number -- the x pos on the map
---@param z number -- the z pos on the map
---@param parentId number|nil -- either object or vehicle id
---@param player Player|nil -- the player class you would like to see the widget or nil for everyone
---@param radius number -- the radius of the MapObject
---@param name string|nil -- the name of the widget (useful when trying to find a widget)
---@return MapObjectWidget -- returns class object
modules.classes.widgets.mapObject:create(id, label, hoverLabel, color, posType, markerType, x, z, parentId, player, radius, name)
```

The class objects functions and variables:

```lua
mapObject.type -- the widgets type, can be used to filter for a specific type of widget

mapObject.playerId -- either players steamId that the popup is assigned to or nil

mapObject.id -- the ui_id of the widget

mapObject.label -- the label

mapObject.hoverLabel -- the hover label

mapObject.color -- the color

mapObject.posType -- the pos type

mapObject.markerType -- the marker type

mapObject.x -- the x pos on the map

mapObject.z -- the z pos on the map

mapObject.radius -- the radius

mapObject.parentId -- either objectId or vehicleId of the parent used for position

mapObject.name -- the name of the widget

mapObject:update() -- update the widget for the assigned player or all players

mapObject:destroy() -- removes the widget for the assigned player or all players

mapObject:save() -- save the widget into the ui service
```

Example usage is the same as `PopupScreen` class.

### modules.classes.widgets.popup

This class is for the `Popup` widget aswell as functions to interact with it. Although you can create an object directly from the class it is recomended to use the UI service `modules.services.ui:createPopup()`.

```lua
---@param id integer -- the ui_id of the widget
---@param visible boolean -- if the popup is visable
---@param text string -- the text on the popup
---@param x number -- x pos
---@param y number -- y pos
---@param z number -- z pos
---@param player Player|nil -- the player class you would like to see the widget or nil for everyone
---@param renderDistance number -- how far the popup is visible for in meters
---@param vehicleParent Vehicle|nil -- gets pos off vehicle if provided
---@param objectParent integer|nil -- gets pos off object if provided
---@param name string|nil -- the name of the widget (useful when trying to find a widget)
---@return PopupWidget -- returns class object
modules.classes.widgets.popup:create(id, visible, text, x, y, z, player, renderDistance, vehicleParent, objectParent, name)
```

The class objects functions and variables:

```lua
popup.type -- the widgets type, can be used to filter for a specific type of widget

popup.playerId -- either players steamId that the popup is assigned to or nil

popup.id -- the ui_id of the widget

popup.visible -- if the popup is visable

popup.text -- the text

popup.x -- x pos

popup.y -- y pos

popup.z -- z pos

popup.renderDistance -- the distance the popup is visible for

popup.vehicleParent -- the vehicle parent to get pos from

popup.objectParent -- the object parent to get pos from

popup.name -- the name of the widget

popup:update() -- update the widget for the assigned player or all players

popup:destroy() -- removes the widget for the assigned player or all players

popup:save() -- save the widget into the ui service
```

### modules.classes.widgets.popupScreen

This class is for the `PopupScreen` widget aswell as functions to interact with it. Although you can create an object directly from the class it is recomended to use the UI service `modules.services.ui:createPopupScreen()`.

```lua
---@param id integer -- the ui_id of the widget
---@param visable boolean -- if the PopupScreen widget is visible on the players screen
---@param text string -- the text for the PopupScreen widget
---@param x integer -- the x pos on the players screen. range from 1 to -1
---@param y integer -- the y pos on the players screen. range from 1 to -1
---@param player Player|nil -- the player class you would like to see the widget or nil for everyone
---@param name string|nil -- the name of the widget (useful when trying to find a widget)
---@return PopupScreenWidget -- returns a class object
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

popupScreen.name -- the name of the widget

popupScreen:update() -- update the widget for the assigned player or all players

popupScreen:destroy() -- removes the widget for the assigned player or all players

popupScreen:save() -- save the widget into the ui service
```

Example usage for a single player:

```lua
local id = server.getMapID() -- get a ui_id to use for the popup

local player = modules.services.player:getPlayerByPeer(1) -- get the player with peer_id of 1

local popupScreen = modules.classes.widgets.popupScreen:create(id, true, "Welcome", 0, 0, player, "welcome_message") -- create a popup for player with peer_id of 1 in the center of their screen that says "Welcome"

popupScreen:update() -- update the popup screen

popupScreen:save() -- save any changes into ui service
```

Example usage for all players:

```lua
local id = server.getMapID() -- get a ui_id to use for the popup

local popupScreen = modules.classes.widgets.popupScreen:create(id, true, "Welcome All", 0, 0, nil, "welcome_message") -- create a popup for all players in the center of their screen that says "Welcome All"

popupScreen:update() -- update the popup screen

popupScreen:save() -- save any changes into ui service
```

Example of updating variables:

```lua
local id = server.getMapID() -- get a ui_id to use for the popup

local popupScreen = modules.classes.widgets.popupScreen:create(id, true, "Welcome All", 0, 0, nil, "welcome_message") -- create a popup for all players in the center of their screen that says "Welcome All"

popupScreen:update() -- update the popup screen

popupScreen.text = "Well now thats different" --  change the text

popupScreen:update() -- update the popup screen. it now says "Well now thats different"

popupScreen:save() -- save any changes into ui service
```

Example of destroying the popup:

```lua
local id = server.getMapID() -- get a ui_id to use for the popup

local popupScreen = modules.classes.widgets.popupScreen:create(id, true, "Welcome All", 0, 0) -- create a popup for all players in the center of their screen that says "Welcome All"

popupScreen:update() -- update the popup screen

popupScreen:destroy() -- removes popup screen from all players

popupScreen:save() -- save any changes into ui service
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
---@param url string -- request or url for the http request
---@param id number -- id is used when there is a reply
---@param func fun(request:HttpRequest, reply: any) | nil -- function to be called when there is a reply
---@return HttpRequest -- returns class object
modules.classes.httpRequest:create(url, id, func)
```

The class objects functions and variables:

```lua
httpRequest.url -- the url of the http request you are making

httpRequest.id -- request id is given by modules.services.http

httpRequest.func -- function to be called when the http request gets its reply
```

### modules.classes.player

This class represents a stormworks player. It made by `modules.services.player` when a player joins or a player dosnt have a class for it. You will not need to manually create this for a player as `modules.services.player` handles all of that.

```lua
---@param peerId number -- players peer_id
---@param steamId string|number -- players steam_id
---@param name string|nil -- players name
---@param admin boolean|nil -- if the player is a server admin
---@param auth boolean|nil -- if the player is authed
---@param objectId integer|nil -- players objectId
---@param perms table|nil -- table of permissions for the player
---@param extra table|nil -- emtpy table for any extra data you need to add to the player
---@return Player -- returns class object
modules.classes.player:create(peerId, steamId, name, admin, auth, objectId, perms, extra)
```

The class objects functions and variables:

```lua
player.peerId -- players peer_id

player.steamId -- players steam_id

player.name -- players name

player.admin -- boolean if the player has server admin

player.auth -- boolean if the player is authed

player.objectId -- players object_id

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
player:setPos(pos) -- teleports player to the inputed matrix

---@return table -- matrix table
player:getPos() -- returns the players position as matrix

---@param title string -- title of the notification
---@param message string -- message of the notification
---@param notificationType number -- notification type
player:notify(title, message, notificationType) -- send a notification to the player

player:save() -- save any changes into player service
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

### modules.classes.task

This class represents a task (function that runs after a set amount of ticks). It is used by `modules.services.task` to manage and run tasks. It must be created via `modules.services.task:create()` to run.

```lua
---@param id number -- id given by task service
---@param period number -- how often the task is to run in ticks
---@param repeating boolean -- if the task repeats
---@param func fun(task: Task) -- the function to run once the period has passed
---@return Task -- return class object
modules.classes.task:create(id, period, repeating, func)
```

The class objects functions and variables:

```lua
task.id -- the id of the task, given to task when created via task service

task.period -- the period in ticks

task.repeating -- if the task repeats after the period has passed

task.paused -- if the task is paused

task.counter -- the tick counter

task.func -- the function to be run after the period has passed

task:setPaused(paused) -- set if the task is paused

task:setPeriod(period) -- set the tick period

task:setRepeating(repeating) -- set if the task is repeating

task:resetCounter() -- reset the counter to 0

task:tick() -- tick the task
```

### modules.classes.vehicle

This class represents a stormworks vehicle. It is use along with `modules.classes.vehicleGroup` to manage the vehicles. You will not need to create an object of this class, you can get the vehicles group by using `modules.services.vehicle:getVehicleGroup()`.

```lua
---@param vehicleId number -- the vehicles vehicle_id
---@param groupId number|string -- the vehicles group_id
---@param loaded boolean|nil -- if the vehicle has been loaded yet
---@param data table -- table of vehicles data
---@param info table -- table of vehicles components
---@return Vehicle -- returns a class object
modules.classes.vehicle:create(vehicleId, groupId, loaded, data, info)
```

The class objects functions and variables:

```lua
vehicle.id -- the vehicles vehicle_id

vehicle.groupId -- the vehicles group_id

vehicle.data -- the vehicles data

vehicle.info -- the vehicles info

---@param vehicle Vehicle -- passes itself as a parameter
vehicle.onDespawn -- event for when the vehicle is despawned

---@param vehicle Vehicle -- passes itself as a parameter
vehicle.onLoaded -- event for when the vehicle has been loaded

vehicle.isLoaded -- if the vehicle is loaded or not

vehicle.isDespawned -- if the vehicle has bene despawned

vehicle:despawned() -- function modules.services.vehicle calls when the vehicle gets despawned

vehicle:loaded() -- function modules.services.vehicle calls when the vehicle is loaded

vehicle:setEditable(state) -- set if the vehicle can be edited

vehicle:setInvulnerable(state) -- set if the vehicle can be damaged

vehicle:despawn(is_instant) -- despawn the vehicle

vehicle:getInfo(update) -- get the vehicles info

vehicle:getData(update) -- get the vehicles data

vehicle:getComponents(update) -- get the vehicles components

vehicle:setTooltip(text) -- set the vehicles tooltip

vehicle:getPos() -- get the pos of the vehicle

vehicle:save() -- save the vehicle to the vehicle service
```

### modules.classes.vehicleGroup

This class represents a stormworks vehicle group. It is use along with `modules.classes.vehicle` to manage the vehicles. You will not need to create an object of this class, you can get the vehicle group by using `modules.services.vehicle:getVehicleGroup()`.

```lua
---@param group_id number|string -- group_id of the vehicle group
---@param owner Player|nil -- the player that owns the vehicle group
---@param spawnTime number|nil -- when the vehicle group was spawned
---@param loaded boolean|nil -- if the vehicle group is loaded
---@param despawned boolean|nil -- the the vehicle group is despawned
---@return VehicleGroup -- returns class object
modules.classes.vehicleGroup:create(group_id, owner, spawnTime, loaded, despawned)
```

The class objects functions and variables:

```lua
vehicleGroup.groupId -- vehicle groups group_id

vehicleGroup.vehicles -- table of vehicles part of the vehicle group

vehicleGroup.ownerId -- steamId of the player that owns the vehicle group

vehicleGroup.spawnTime -- time the vehicle was spawned

---@param vehicleGroup VehicleGroup -- passes itself as a parameter
vehicleGroup.onDespawn -- event for when the vehicle group is despawned

---@param vehicleGroup VehicleGroup -- passes itself as a parameter
vehicleGroup.onLoaded -- event for when the vehicle group is loaded

vehicleGroup.isLoaded -- if the vehicle group is loaded

vehicleGroup.isDespawned -- if the vehicle group is despawned

vehicleGroup:despawned() -- function modules.services.vehicle calls when the vehicle group is despawned

vehicleGroup:loaded() -- function modules.services.vehicle calls when the vehicle group is loaded

---@param newowner Player -- the new player you want to own the vehicle group
vehicleGroup:setOwner(newowner) -- set the new owner for the vehicle group

vehicleGroup:getOwner() -- returns the owners player class object

---@param vehicle Vehicle -- vehicle you want to add to the vehicle group
vehicleGroup:addVehicle(vehicle) -- add a vehicle to the vehicle group

vehicleGroup:setEditable(state) -- set if the vehicle group can be edited

vehicleGroup:setInvulnerable(state) -- set if the vehicle group can be damaged

vehicleGroup:despawn(is_instant) -- despawns the vehicle group

vehicleGroup:getInfo(update) -- get the combined info from all the vehicles in the vehicle group

vehicleGroup:setTooltip(text) -- set the tooltip for all the vehicles in vehicle group

vehicleGroup:save() -- save the vehicle group to the vehicle service
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

Example usage of saving and loading a service:

```lua
service = modules.services:createService("service", "its a service", {"ChickenMst"})

function service:initService()
    self.value = 1 -- create the value in init
end

function service:startService()
    modules.libraries.logging:info("service", "value is: "..self.value)

    if modules.addonReason == "reload" then
        self:_load() -- check if the addon has reloaded and the load from gsave
    end

    modules.libraries.logging:info("service", "value is: "..self.value)

    self.value = self.value + 1 -- change a value

    self:_save() -- save the service
end

function service:_save()
    modules.libraries.gsave:saveService("service", self) -- this saves `self` which is the service into gsave
end
 
function service:_load()
    local loaded = modules.libraries.gsave:loadService("service") -- laod the service from gsave

    self.value = loaded.value -- set the value in the service to the one saved in gsave
end
```

### modules.libraries.json

This library turns lua tables into json strings and vice versa.

```lua
---@param obj table|number|string|boolean|nil -- the table, number, string, boolean to turn into a json string
---@param asKey boolean|nil -- used internaly
---@return string -- returns the encoded json string
modules.libraries.json:encode(obj, asKey) -- turns lua variables into json string

---@param str string -- the json string
---@param pos integer|nil -- used internaly
---@param endDelim string|nil -- used internaly
---@return any
---@return integer -- returns the decoded lua variables
modules.libraries.json:decode(str, pos, endDelim) -- turns json string into lua variables
```

Example usage:

```lua
local table = {value=1, otherValue=2} -- the table we are going to encode

local encoded = modules.libraries.json:encode(table) -- returns the table as a json string: {"value":1,"otherValue":2}

local decoded = modules.libraries.json:decode(encoded) -- returns the decoded table from the json string: decoded == table
```

### modules.libraries.logging

This library handles all the logging for `modules`. it can either log into chat or into the console that can be see by using a program called 'debugView'.

```lua
modules.libraries.logging.logs -- table of all the logs that have happened since last reload, world create or world load

modules.libraries.logging.logtypes = { -- table used to look up log levels
    DEBUG = 1,
    INFO = 2,
    WARNING = 3,
    ERROR = 4
}

modules.libraries.logging.loglevel -- setting used to tell if the log is above or equal to the the level you want printed into chat. this can be changed via "logginglevel" in settings

modules.libraries.logging.loggingdetail -- setting for if you have something that spam chat you would check if the detail is full, otherwise you would only do one log sumarising the action. can be changed to either "minimal" or "full" via "loggingdetail" in settings.

modules.libraries.logging.loggingmode -- setting to set if you want it to log to chat or to console. can be changed to "chat" or "console" via "loggingmode" in settings

---@param logtype number -- the log type in number form
---@param title string -- the title of the log
---@param message string -- the message for the log
---@param ... any -- any values for formating the message
modules.libraries.logging:log(logtype, title, message, ...) -- log something. preferably use one of the `info()`, `debug()`, `warning()` or `error()` functions as it removes the need for you to figure out the log type

---@param state string -- the log level you would like to set to print in chat
modules.libraries.logging:setLogLevel(state) -- sets the loglevel to the inputed strings corresponding number value

---@param title string -- title of the log
---@param message string -- message of the log
---@param ... any -- any values for formating the message
modules.libraries.logging:error(title, message, ...) -- error log

---@param title string -- title of the log
---@param message string -- message of the log
---@param ... any -- any values for formating the message
modules.libraries.logging:warning(title, message, ...) -- warning log

---@param title string -- title of the log
---@param message string -- message of the log
---@param ... any -- any values for formating the message
modules.libraries.logging:info(title, message, ...) -- info log

---@param title string -- title of the log
---@param message string -- message of the log
---@param ... any -- any values for formating the message
modules.libraries.logging:debug(title, message, ...) -- debug log
```

Example usage:

```lua
modules.libraries.logging:info("log title", "log message") -- this usage is the same for all of the log types

-- here is an example of the message formating
local value = 10

modules.libraries.logging:info("log title", "log message and value: %s", value) -- the log message will be converted into "log message and value: 10"
```

### modules.libraries.settings

This library handles all of the settings for `modules`. It uses the `settings.lua` file to load settings into modules.

```lua
---@param name string -- name of the setting
---@param value any -- what the settings value is
---@param default any -- the default value of the setting
---@return any -- returns either nil if the setting name already is being used or the setting once its created
modules.libraries.settings:create(name, value, default) -- creates a new setting, not persistent

---@param name string
---@param default any
---@return any -- settngs value
modules.libraries.settings:getSetting(name, default) -- get a setting value. if the setting doesnt exist or it dosnt have a value it returns the inputed default

---@param name string -- name of the setting
---@param createSettingIfNotExists boolean -- if the setting doesnt exist should it create it
---@param default any -- default value if it dosnt exist
---@return any -- returns either the value, default or inputed default
modules.libraries.settings:getValue(name, createSettingIfNotExists, default) -- prefered way of getting a setting as it checks for both the value and the default if neither exists it creates the setting with the inputed default

---@param name string -- name of the setting
---@param value any -- the value to set it to
modules.libraries.settings:setValue(name,value) -- set the value of a setting, not persistent

---@param name string -- name of the setting
---@param default any -- the default to set to
modules.libraries.settings:setDefault(name,default) -- set the default value of a setting, not persistent

---@param name string -- name of the setting
modules.libraries.settings:resetToDefault(name) -- resets the settings value to its default, not persistent
```

Example `create()` usage:

```lua
modules.libraries.settings:create("setting", true, false) -- create a setting called "setting"
```

Example `getSetting()` usage:

```lua
local value = modules.libraries.settings:getSetting("value", 1) -- get a settings value if it dosnt exist use the value given
```

Example `getValue()` usage:

```lua
local value = modules.libraries.settings:getValue("value", true, 1) -- get a settings value if it doesnt exist check its default otherwise create the setting with the inputed default
```

Example `setValue()` usage:

```lua
modules.libraries.settings:setValue("setting", false) -- change settings value, dosnt persist after reload
```

Example `setDefault()` usage:

```lua
modules.libraries.settings:setDefault("setting", true) -- change settings default value, dosnt persit after reload
```

Example `resetToDefault()` usage:

```lua
modules.libraries.settings:resetToDefault("setting") -- change the settings value to its default
```

Example `settings.lua` layout:

```lua
settings = {
    logginglevel = {value = 1, default = 4}, -- Default log level set to ERROR
    loggingdetail = {value = "full", default = "full"}, -- Default logging detail set to full
    targetTps = {value = 0, default = 0}, -- Default target TPS set to 0
}

return settings
```

### modules.libraries.table

This library has functions to manipulate tables.

```lua
---@param tbl table -- the table to convert
---@param indent number|nil -- the current indentation level (default is 0)
---@return string -- the string representation of the table
modules.libraries.table:tostring(tbl, indent) -- turn a table into a string, helpful for debuging

---@param tbl table -- the table to strip
---@param typeOf string -- the type to strip from the table
---@return string -- returns the table without the specifyed type
modules.libraries.table:strip(tbl, typeOf) -- strip a table of a specific type of variable

---@param tbl any table to copy
---@return table -- a deep copy of the table
modules.libraries.table:deepCopy(tbl) -- returns a deep copy of a table
```

Example `tostring()` usage:

```lua
local table = {value=1}

local string = modules.libraries.table:tostring(table) -- turns the table into a string representation

modules.libraries.logging:info("table", string) -- print the table string
```

Example `strip()` usage:

```lua
local table = {value=1, stringvalue="1"}

local striped = modules.libraries.table:strip(table, "string") -- strip the table of all strings

-- table is now: table = {value=1}
```

## modules.services

This table stores all the services and the functions to create a service.

```lua
modules.services.created -- table of services that have been created

modules.services.ordered -- the order in which the services where made. used to determain the start and init order

---@param name string -- name of the service
---@param description string -- a description of the service
---@param authors table<string> -- table of authors for the service
modules.services:createService(name, description, authors) -- create a service

---@param name string -- name of the service to get
---@return Service -- returns the requested service
modules.services:getService(name) -- get a service from services
```

Example `createService()` usage:

```lua
service = modules.services:createService("service", "its a service", {"ChickenMst"}) -- create the service

function service:initService()
    self.value = 10 -- put any values or things you need before the service starts
end

function service:startService()
    modules.libraries.logging:info("service", "value: "..self.value) -- anything you need to run once its started
end
```

### modules.services.addon

This services handles the addons for modules. Addons allow for the extention of functionality for modules or your addon. It allows for drop in addons with no need for changing any internal lua scripts.

```lua
modules.services.addon.addons -- table of all the created addons

---@param name string -- name of the addon
---@param version string|number -- addons version
---@param description string -- a description of the addon
---@param authors table<string> -- addons authors
---@return Addon -- returns Addon class object
modules.services.addon:createAddon(name, version, description, authors) -- create an addon

---@param name string -- name of the addon to remove
modules.services.addon:disconnect(name) -- remove an addon from addon service

---@param name string -- name of the addon to enable
modules.services.addon:enable(name) -- enables an addon (addons are enabled by default)

---@param name string -- name of the addon to disable
modules.services.addon:disable(name) -- disable an addon (connections and commands are removed when disabled)
```

Example `createAddon()` usage:

```lua
local addon = modules.services.addon:createAddon("test", 1, "Test Addon", {"ChickenMst"}) -- create the addon via addon service

function addon:initAddon()
-- anything needed before the addon starts goes here
end

function addon:startAddon()
    modules.libraries.logging:info("test", "Test addon started")
end
-- look at modules.classes.addon for example with commands and connections
```

Example `disconnect()` usage:

```lua
-- assuming you have made an addon named "test"
modules.services.addon:disconnect("test") -- disables the addon and "deletes" it
```

Example `disable()` and `enable()`:

```lua
-- assuming you have an addon named "test" that has a `onTick` connection
modules.services.addon:disable("test") -- disable the addon. its `onTick` connection gets removed

modules.services.addon:enable("test") -- enable the addon. it will run the addons `startAddon()` again
-- addon is now enabled and running again
```

### modules.services.command

This service handles the custom commands, allowing for things like command aliases permision checks and dynamicly creating and destroying commands.

```lua
modules.services.command.commands -- table of the created commands

---@param commandstr string -- main command as a string
---@param alias table<string> -- aliases for the command
---@param perms table<string> -- permissions required to run the command
---@param description string -- description of the command
---@param func fun(player:Player, full_message, command, args, hasPerm) -- function to run when the command is called
---@return Command -- returns Command class object
modules.services.command:create(commandstr, alias, perms, description, func) -- create a command

---@param commandstr string -- main command string of the command to enable
modules.services.command:enable(commandstr) -- enable a command (commands are enabled by default)

---@param commandstr string -- main command string of the command to disable
modules.services.command:disable(commandstr) -- disables the command so it cant be ran

---@param commandstr string -- main command string of the command to
modules.services.command:remove(commandstr) -- removes the cpmmand from the command service

modules.services.command:run(command, full_message, player, args) -- runs a command with inputed argumnets allowing for things like runing a command for a player

---@param command string -- the command string or alias used to get a command
modules.services.command:getCommand(command) -- return a commmand that matches the inputed command string or alias

modules.services.command:getComamnds() -- returns all commands

---@param player Player -- player to check
---@param command Command -- command to check
---@return boolean -- if the player has the permission
modules.services.command:hasPerm(player, command) -- returns boolean of if the player has the permissions to run the command
```

Example `create()` usage:

```lua
modules.services.command:create("test",{"t"},{"perm"},"test command", function(player, full_message, command, args, hasPerm) -- create command "test" with alias "t" and permsion "perm"
    -- do things in here

    -- player is the player who ran the commands Player class
    -- full_message is the full message eg: "?test arg1"
    -- command is the actual command that was ran to call the command. good for telling if the player is using an alias
    -- args is a table full of all the arguments for the command. usage of an argument:
    local arg1 = args[1] -- sets arg1 to the number 1 argument in the args table
    -- hasPerm is a boolean for if the player that ran the command has one of the permisions required to run the command
end)
```

Example `disable()` and `enable()` usage:

```lua
-- assuming you have already created the command "test"
modules.services.command:disable("test") -- the command "test" will now not run when called

modules.services.command:enable("test") -- the command "test" can be ran again
```

Example `remove()` usage:

```lua
-- assuming you have already created the command "test"
modules.services.command:remove("test") -- this removes the command from the command service in turn destroying it. meaning the command cannot be ran anymore
```

### modules.services.http

This service handles all of the http requests allowing for easier handling and usage. For this to work it requires extra handleing on the backend side.

```lua
modules.services.http.requests -- table of all the HttpRequest class objects for the http requests that have been sent

modules.services.http.groupedRequests -- table to temparaily store request ids to be grouped into one request

modules.services.http.counter -- counter for the request number

modules.services.http.backendPort -- setting for which port the backend is on. can be set via "backendPort" in settings

---@param port number -- port to send the request on
---@param url string -- the url of the request, eg: "http://localhost:5006/test"
---@param callback fun(request:HttpRequest, reply: any) | nil -- the function to be run when it gets a response
---@param groupedRequest boolean -- if it it to be grouped
---@return HttpRequest|nil -- returns HttpRequest class object
modules.services.http:get(port, url, callback, groupedRequest) -- send a http request via the backend
```

Example normal `get()` usage:

```lua
modules.services.http:get(50,"http://localhost:8080/test?value=1",function(request, reply) -- send a http request to be queried by the backend
    modules.libraries.logging:info("http", "got a response of: "..tostring(reply)) -- log the reply
end)
```

Example grouped `get()` usage:

```lua
modules.services.http:get(50,"http://localhost:8080/test?value=1",function(request, reply)
    modules.libraries.logging:info("http", "got a response of: "..tostring(reply)) -- log the reply
end, true) -- set it as a grouped request

modules.services.http:get(50,"http://localhost:8080/test?value=2",function(request, reply)
    modules.libraries.logging:info("http", "got a response of: "..tostring(reply)) -- log the reply
end, true) -- set it as a grouped request

-- both will be sent in one request on the next tick and will also get a reply at the same time
```

### modules.services.player

This service handles all of the players, it also stores the Player class objects of the players.

```lua
---@param player Player -- Player class object of the player that joined
modules.services.player.onJoin -- event for when a player joins. use this to make sure the players class has been made and preped properly

---@param player Player -- Player class object of the player that left
modules.services.player.onLeave -- event for when a player leaves. use this to make sure the players class has been made and preped properly

---@param player Player -- Player class object of the player that loaded
modules.services.player.onLoad -- event for when the players object has loaded, can be used to tell if a player has joined fully and is ready for ui widgets

modules.services.player.players -- table of Player class objects. indexed via players steam_id

modules.services.player.peerIdIndex -- table of players steam_id indexed to their peer_id for faster searching of players Player class object

---@param steam_id string -- steam_id of the Player class object you are trying to get
---@return Player|nil -- returns Player class object
modules.services.player:getPlayer(steam_id) -- get a players class object via their steam_id

---@param peer_id number -- the peer_id of the Player class object you are trying to get
---@return Player|nil -- returns Player class object
modules.services.player:getPlayerByPeer(peer_id) -- get a player class object via their peer_id

---@return table<string, Player> -- returns a table of all the players (online and not) indexed by their steam_id
modules.services.player:getPlayers() -- get all of the players (this includes offline players)

---@return table<string, Player> -- returns a table of all the players that are online. indexed by their steam_id
modules.services.player:getOnlinePlayers() -- all of the players that are currently online

---@param player1 Player -- first player
---@param player2 Player -- second player
---@return boolean -- returns boolean of if the players are the same
modules.services.player:isSamePlayer(player1, player2) -- check if a Player class object is the same as another
```

Example `getPlayer()` usage:

```lua
local player = modules.services.player:getPlayer("10912804973189") -- get a player via their steam_id

-- returns Player class object, so you can use things like
player:kick()
```

Example `getPlayerByPeer()` usage:

```lua
local player = modules.services.player:getPlayerByPeer("2") -- get the player with peer_id of 2. same as `getPlayer()` just using peer_id instead
```

Example `getPlayers()` usage:

```lua
local players = modules.services.player:getPlayers() -- gets all the players that have been saved by modules

-- you can iterate over the table like this
for steam_id, player in pairs(players) do
    modules.libraries.logging:info("players", "player with steam_id: "..steam_id.." exists.")
end

-- or
for _, player in pairs(players) do
    modules.libraries.logging:info("players", "player with steam_id: "..player.steamId.." exists.")
end
```

Example `getOnlinePlayers()` usage:

```lua
local players = modules.services.player:getOnlinePlayers() -- returns a table of all the players that are currently online

-- same as `getPlayers()` but with only the players that are actively online / in game
```

Example `isSamePlayer()` usage:

```lua
local player1 = modules.services.player:getPlayer("21986791321387") -- get the first player with inputed steam_id

local player2 = modules.services.player:getPlayerByPeer("21") -- get the second player with inputer peer_id

local isTheSame = modules.services.player:isSamePlayer(player1, player2) -- checks the steamId's of both player classes to determain if they are the same. returns true if they are the same or false if they are not
```

### modules.services.task

This service manages `Task` class objects.

```lua
modules.services.task.tasks -- table of all tasks indexed via the tasks id

modules.services.task:create(period, func, repeating) -- create a task
```

Example `create()` usage:

```lua
local task = modules.services.task:create(10, function(task)
    modules.libraries.logging:info("Task", "this is my id: %s" task.id)
end, true) -- create a task that runs every 10 ticks the logs its task id
```

### modules.services.tps

This service handles calculating and regulating/limiting the tps of the game.

```lua
modules.services.tps.targetTPS -- setting for the tps you are trying to get to. can be set via "targetTPS" setting or `setTPS()`

modules.services.tps.tps -- the current tps of the game or server

---@return number -- returns the TPS (ticks per second)
modules.services.tps:getTPS() -- get the current tps

---@param targetTPS number -- the target tps you would like to set the game to
modules.services.tps:setTPS(targetTPS) -- sets the target tps for the tps service
```

Example `getTPS()` usage:

```lua
local tps = modules.services.tps:getTPS() -- returns the servers current tps as a number eg: 54.28760960

-- the value it returns isnt rounded so if you only want to have only to 1 decimal place eg: 30.2 do
tps = math.floor(tps)
```

Example `setTPS()` usage:

```lua
-- by default the target tps is set to 0 which is its off state setting it to anything lower that 0 will also set it to 0. setting it above 62.5 (game max tps) does nothing as it cant magicly make the tps go up
modules.services.tps:setTPS(10) -- this sets the target tps to 10

-- the way the tps the regulating/limiting work is it lags the game until its under the target tps or as close as it can get it. so if you set the target tps to 40 it might end up lagging it until its 39.831 etc, generaly it will be within less than 1 tps of the target

-- slowing down the tps of the game not only slows how fast the physics runs but also how often things like `onTick` are called, so use this service with care
```

### modules.services.ui

This service handles the ui widgets for players. currently the ui widgets dont persist over saves and reloads.

```lua
modules.services.ui.widgets -- table of all the created ui widgets

---@param player Player -- the Player class object to search for ui widgets
---@return table -- returns a table of all widgets that owned by the player
modules.services.ui:getPlayersWidgets(player) -- get all the ui widgets ownes by a player

---@param player Player -- the Player class object to search for ui widgets
---@return table -- returns a table of all the ui widgets that are shown to the player
modules.services.ui:getPlayersShownWidgets(player) -- get all the widgets shown to a player, this includes the ones that are owned by the player aswell

---@param name string -- name of the widget to get
modules.services.ui:getWidgetsByName(name) -- returns table of widgets that match the inputed name

---@param id integer -- the widgets id
modules.services.ui:removeWidget(id) -- remove/destroy a widget with inputed id

---@param id integer -- the widgets id
---@return Widget|nil -- returns a widget with that has the inputed id
modules.services.ui:getWidget(id) -- get a widget by its id

---@param text string -- the text to display in the popup
---@param x number -- the horizontal position of the popup (default is 0)
---@param y number -- the vertical position of the popup (default is 0)
---@param visable boolean -- whether the popup should be visible (default is true)
---@param player Player|nil -- the player to show the popup to (default is nil, which means all players)
---@return PopupScreenWidget -- returns the created widget
modules.services.ui:createPopupScreen(text, x, y, visable, player) -- create a popup screen widget

---@param text string -- The text to display in the popup
---@param x number|nil -- The x position in the world or relitive to the parent (default is 0)
---@param y number|nil -- The y position in the world or relitive to the parent (default is 0)
---@param z number|nil -- The z position in the world or relitive to the parent (default is 0)
---@param renderDistance number|nil -- The distance at which the popup is visible (default is 100)
---@param visable boolean|nil -- Whether the popup should be visible (default is true)
---@param player Player|nil -- The player to show the popup to (default is nil, which means all players)
---@param vehicleParent Vehicle|nil -- The vehicle to attach the popup to (default is nil)
---@param objectParent integer|nil -- The object ID of the object to attach the popup to (default is nil)
---@param name string|nil -- The name of the popup
---@return PopupWidget
modules.services.ui:createPopup(text, x, y, z, renderDistance, visable, player, vehicleParent, objectParent, name) -- create a popup widget

---@param label string|nil -- The label to display on the map
---@param hoverLabel string|nil -- The label to display when hovering over the map object
---@param color Color|nil -- The color of the map object
---@param posType integer|nil -- The position type (0 for world position, 1 for relative to vehicle, 2 for relative to object)
---@param markerType integer|nil -- The type of marker to display
---@param x number|nil -- The x position in the world or relitive to the parent
---@param z number|nil -- The z position in the world or relitive to the parent
---@param parentId integer|nil -- The ID of the parent object or vehicle
---@param player Player|nil -- The player to show the map object to (default is nil, which means all players)
---@param radius number|nil -- The radius of the map object (default is 0)
---@param name string|nil -- The name of the map object
---@return MapObjectWidget
modules.services.ui:createMapObject(label, hoverLabel, color, posType, markerType, x, z, parentId, player, radius, name) -- create a mapObject widget

---@param text string|nil -- The text to display on the map label
---@param labelType number|nil -- The type of label to display
---@param x number|nil -- The x position in the world
---@param z number|nil -- The z position in the world
---@param player Player|nil -- The player to show the map label to (default is nil, which means all players)
---@param name string|nil -- The name of the map label
---@return MapLabelWidget
modules.services.ui:createMapLabel(text, labelType, x, z, player, name) -- create a mapLabel widget
```

Example `getPlayersWidgets()` usage:

```lua
local widgets = modules.services.ui:getPlayersWidgets(player) -- gets all the widgets owned by the player eg the players player class object was used to make them

-- the table that is returned isnt index by the widgets id, so if you want to find a specific widget via this you will have to make your own custom handling
```

Example `getPlayersShownWidgets()` usage:

```lua
local widgets = modules.services.ui:getPlayersShownWidgets(player) -- gets all the widgets shown to the player, this includes widgets that are shown to all players and also the widgets owned by the player

-- the table that is returned isnt index by the widgets id, so if you want to find a specific widget via this you will have to make your own custom handling
```

Example `removeWidget()` usage:

```lua
modules.services.ui:removeWidget(id) -- by removing a widget via its id it is removed from all shown players and then destroyed
```

Example `getWidget()` usage:

```lua
local widget = modules.services.ui:getWidget(id) -- returns the widget class object corosponding with the inputed id
```

Example `createPopupScreen()` usage:

```lua
local widget = modules.services.ui:createPopupScreen("this is text on a popup screen ui element", 0.5, 0, true) -- create a popup screen widget for everyone


local player = modules.service.player:getPlayer("9887961374179373") -- get a Player class object

local widget = modules.services.ui:createPopupScreen("this is text on a popup screen ui element", 0.5, 0, true, player) -- create a widget "owned" by inputed player


local widget = modules.services.ui:createPopupScreen("this is text on a popup screen ui element") -- this is the minimal amount of aguments you can do with it still having text (the defaults are "",0,0,true,nil)
```

### modules.services.vehicle

This service handles the tracking of players vehicles. it provides events that can be connected into for all of the stages of a vehicle spawning.

```lua
modules.services.vehicle.loadingVehicles -- table of VehicleGroup class objects that are currently being loaded

modules.services.vehicle.loadedVehicles -- table of VehicleGroup class objects that have been loaded

---@param vGroup VehicleGroup -- the vehicle group of the vehicle that was spawned
---@param vehcile_id number -- vehicle_id of the vehicle that was spawned
modules.services.vehicle.onVehicleSpawn -- event for when a vehicle is spawned

---@param vGroup VehicleGroup -- the vehicle group of the vehicle that was loaded
---@param vehcile_id number -- vehicle_id of the vehicle that was loaded
modules.services.vehicle.onVehicleLoad -- event for when a vehicle has loaded

---@param vGroup VehicleGroup -- the vehicle group of the vehicle that was despawned
---@param vehcile_id number -- vehicle_id of the vehicle that was despawned
modules.services.vehicle.onVehicleDespawn -- event for when a vehicle is despawned

---@param vGroup VehicleGroup -- the vehicle group that was loaded
modules.services.vehicle.onGroupLoad -- event for when a vehicle group has fully loaded

---@param vGroup VehicleGroup -- the vehicle group that was despawned
modules.services.vehicle.onGroupDespawn -- event for when a vehicle group has been despawned

---@param vehicle_id number -- the vehicle_id of one of vehicles in a group that you are trying to find
---@param mustBeLoaded boolean|nil -- if the vehicle group needs to be loaded
---@return VehicleGroup|nil -- returns VehicleGroup class object that contains the specifyed vehicle_id
modules.services.vehicle:getVehicleGroup(vehicle_id, mustBeLoaded) -- get the vehicle group of the vehicle that belongs to the inputed vehicle_id

---@param player Player -- player to check for vehicles
---@return table<number, VehicleGroup> -- table of VehicleGroup class objects indexed by group_id
modules.services.vehicle:getPlayersVehicleGroups(player) -- get all vehicle groups owned by a player
```

Example `getVehicleGroup()` usage:

```lua
local vehicleGroup = modules.services.vehicle:getVehicleGroup(10, true) -- gets the vehicle group that the vehicle with the vehicle_id of 10 belongs to
```

Example `getPlayersVehicleGroups()` usage:

```lua
local player = modules.services.player:getPlayerByPeer(1) -- get player with peerId of 1

local vehicleGroups = modules.services.vehicle:getPlayersVehicleGroups(player, true) -- get a tabel of all the vehicle groups that are owned by the player and are loaded
```
