modules.classes.addon = {} -- table of addon functions

---@param name string
---@param version string|number
---@param author string
---@param description string
---@return table
function modules.classes.addon:create(name, version, author, description)
    local addon = {
        name = name,
        version = version,
        author = author,
        description = description,
        enabled = true,
        func = {}
    }

    function self:connect(func)
        table.insert(self.func, func)
    end

    function self:enable()
        self.enabled = true
    end

    function self:disable()
        self.enabled = false
    end

    return addon
end