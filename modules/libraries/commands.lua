modules.libraries.commands = {} -- table of command functions

---@type Command[]
modules.libraries.commands.commands = {} -- table of commands

---@param commandstr string
---@param alias table
---@param description string
---@param func fun(full_message, peer_id, is_admin, is_auth, command, ...)
---@return boolean
function modules.libraries.commands:create(commandstr, alias, description, func)
    commandstr = self:cleanCommandString(commandstr) -- clean command string
    -- check if command already exists
    local existing_command = self.commands[commandstr]
    if existing_command then
        modules.libraries.logging:warning("libraries.commands", "Command already exists: " .. commandstr)
        return false
    end

    -- check if alias already exists
    if type(alias) == "table" then
        for _, a in pairs(alias) do
            -- check if alias is the same as its command
            if self:cleanCommandString(a) == self:cleanCommandString(commandstr) then
                modules.libraries.logging:warning("libraries.commands", "Alias: "..a.." can't be the same as command: "..commandstr.." | aborting command creation")
                return false
            end
            for _, cmd in pairs(self.commands) do
                if type(cmd.alias) == "table" then
                    for _, existing_a in pairs(cmd.alias) do
                        if self:cleanCommandString(a) == self:cleanCommandString(existing_a) then -- check if alias is the same as another alias
                            modules.libraries.logging:warning("libraries.commands", "Alias: "..a.." for command: "..commandstr.." already exists | aborting command creation")
                            return false
                        elseif self:cleanCommandString(a) == self:cleanCommandString(cmd.commandstr) then -- check if alias is the same as another command
                            modules.libraries.logging:warning("libraries.commands", "Alias: "..a.." can't be the same as command: "..cmd.commandstr.." | aborting command creation")
                            return false
                        end
                    end
                end
            end
        end
    else
        modules.libraries.logging:warning("libraries.commands", "Alias is not a table, aborting command creation")
        return false
    end

    -- if didnt return false, create command
    local command = modules.classes.command:create(commandstr, alias, description, func)
    modules.libraries.logging:info("libraries.commands", "Command created: " .. commandstr)

    self.commands[commandstr] = command -- add command to table

    return true
end

-- enables command so it can get run, by default when created it is enabled
---@param commandstr string
function modules.libraries.commands:enable(commandstr)
    if self.commands[commandstr] then
        self.commands[commandstr]:enable()
        modules.libraries.logging:debug("libraries.commands", "Command enabled: " .. commandstr)
    else
        modules.libraries.logging:warning("libraries.commands", "Command not found: " .. commandstr)
    end
end

-- disables command so it cant get run
---@param commandstr string
function modules.libraries.commands:disable(commandstr)
    if self.commands[commandstr] then
        self.commands[commandstr]:disable()
        modules.libraries.logging:debug("libraries.commands", "Command disabled: " .. commandstr)
    else
        modules.libraries.logging:warning("libraries.commands", "Command not found: " .. commandstr)
    end
end

-- removes command
---@param commandstr string
function modules.libraries.commands:remove(commandstr)
    if self.commands[commandstr] then
        self.commands[commandstr] = nil
        modules.libraries.logging:debug("libraries.commands", "Command removed: " .. commandstr)
    else
        modules.libraries.logging:warning("libraries.commands", "Command not found: " .. commandstr)
    end
end

-- removes ? from command
---@param command string
---@return string
function modules.libraries.commands:cleanCommandString(command)
    local cleaned = command:lower():gsub("^%?", "")
    return cleaned
end