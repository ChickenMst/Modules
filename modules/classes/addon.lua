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
        func = {},
        connect = function(func)
            self.func = func -- set the function to the addon
        end,
        enable = function()
            self.enabled = true
        end,
        disable = function()
            self.enabled = false
        end
    }

    return addon
end