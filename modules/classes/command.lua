modules.classes.command = {} -- table of command functions

---@param maincommand string
---@param alias table
---@param description string
---@param func any
---@return Command
function modules.classes.command:create(maincommand, alias, description, func)
    ---@class Command
    local command = {
        maincommand = maincommand,
        alias = alias,
        description = description,
        func = func,
        enabled = true,
    }

    -- enables command so it cant get run, defaults to true
    function command:enable()
        self.enabled = true
    end

    -- disables command so it cant get run
    function command:disable()
        self.enabled = false
    end

    return command
end