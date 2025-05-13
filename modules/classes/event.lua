modules.classes.event = {} -- table of event functions

---@return Event
function modules.classes.event:create()
    ---@class Event
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