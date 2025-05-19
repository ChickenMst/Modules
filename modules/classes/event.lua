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
        if self.isFireing then
            table.insert(self.connectionsToRemove, connection)
        else
            self:_disconnectImidiate(connection)
        end
    end

    function event:_disconnectImidiate(connection)
        self.connections[connection.id] = nil
        table.remove(self.connectionsOrder, connection.index)

        for i = connection.index, #self.connectionsOrder do
            local _connection = self.connections[self.connectionsOrder[i]]
            _connection.index = _connection.index - 1
        end
        
        connection.connected = false
        connection.parentEvent = nil
        connection.id = nil
        connection.index = nil
    end

    function event:fire(...)
    end

    return event
end