modules.classes.addon = {} -- table of addon functions

---@param name string
---@param version string|number
---@param author string
---@param description string
---@return Addon
function modules.classes.addon:create(name, version, author, description)
    ---@class Addon
    ---@field init function
    local addon = {
        name = name,
        version = version,
        author = author,
        description = description,
        enabled = true,
        connections = {}, ---@type table<any, EventConnection>
        commands = {}, ---@type table<string, Command>
    }

    -- enables the addon so it can get run
    function addon:enable()
        self.enabled = true
    end

    -- disables addon so it doesnt get run
    function addon:disable()
        self.enabled = false
    end

    ---@param connection EventConnection|nil
    function addon:addConnection(connection)
        if connection then
            table.insert(self.connections, connection)
        end
    end

    function addon:removeConnections()
        for i, connection in pairs(self.connections) do
            connection:disconnect() -- disconnect the connection
            self.connections[i] = nil -- remove the connection from the connections table
        end
    end

    ---@param command Command|nil
    function addon:addCommand(command)
        if command then
            table.insert(self.commands, command) -- add the command to the addon
        end
    end

    function addon:removeCommands()
        for i, command in pairs(self.commands) do
            modules.libraries.commands:remove(command.commandstr) -- remove the command from the commands table
            self.commands[i] = nil -- remove the command from the addon
        end
    end

    return addon
end