modules.classes.event = {} -- table of event functions

---@return Event
function modules.classes.event:create()
    ---@class Event
    local event = {
        currentId = 0,
        connections = {},---@type EventConnection[]
        connectionsOrder = {},
        connectionsToRemove = {},
        connectionsToAdd = {},
        isFireing = false,
        hasFiredOnce = false,
    }

    function event:connect(callback)
        self.currentId = self.currentId + 1

        local connection = modules.classes.connection:create(callback)
        self.connections[self.currentId] = connection

        connection.parentEvent = self
        connection.connected = false
        connection.id = self.currentId
        connection.index = -1

        if self.isFireing then
            table.insert(self.connectionsToAdd, connection)
        else
            self:_connectionFinalize(connection)
        end
    end

    function event:_connectionFinalize(connection)
        table.insert(self.connectionsOrder, connection.id)

        connection.index = #self.connectionsOrder
        connection.connected = true
    end

    function event:disconnect(connection)

    end

    function event:fire(...)
    end

    return event
end