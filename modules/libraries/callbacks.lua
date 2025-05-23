modules.libraries.callbacks = {} -- table of callback functions

modules.libraries.callbacks.events = {} -- table of events

---@param name string
---@param callback function
---@return EventConnection
function modules.libraries.callbacks:connect(name, callback)
    local event = self:_initCallback(name) -- initialize the callback

    return event:connect(callback) -- connect the callback to the event
end

---@param name string
---@param callback function
---@return EventConnection
function modules.libraries.callbacks:once(name, callback)
    local event = self:_initCallback(name) -- initialize the callback

    return event:once(callback) -- connect the callback to the event
end

---@param name string
---@return Event
function modules.libraries.callbacks:_initCallback(name)
    local event = modules.libraries.callbacks.events[name]

    if event then
        return event
    end

    if not event then
        event = modules.libraries.events:create() -- create a new event object
        self.events[name] = event -- add the event to the table
    end

    local existing = _ENV[name] -- check if the event already exists in the global environment

    if existing then
        _ENV[name] = function(...)
            existing(...)
            event:fire(...)
        end
    else
        _ENV[name] = function(...)
            event:fire(...)
        end
    end

    return event -- return the event
end