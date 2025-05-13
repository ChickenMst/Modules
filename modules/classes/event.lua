modules.classes.event = {} -- table of event functions

---@return event
function modules.classes.event:create()
    ---@class event
    local event = {
        listeners = {},
    }

    function event:connect(callback)
        table.insert(self.listeners, callback)
    end

    function event:fire(...)
        for _, listener in ipairs(self.listeners) do
            listener(...)
        end
    end

    return event
end