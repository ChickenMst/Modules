modules.classes.addon = {} -- table of addon functions

---@param name string
---@param version string|number
---@param author string
---@param description string
---@return Addon
function modules.classes.addon:create(name, version, author, description)
    ---@class Addon
    local addon = {
        name = name,
        version = version,
        author = author,
        description = description,
        enabled = true,
        func = {}
    }

    -- will override functions inside addon if ran a func alread exists
    ---@param func table
    function addon:connect(func)
        self.func = func -- set the function to the addon
    end

    -- enables the addon so it can get run
    function addon:enable()
        self.enabled = true
    end

    -- disables addon so it doesnt get run
    function addon:disable()
        self.enabled = false
    end

    return addon
end