modules.libraries.logging = {} -- table of logging functions

modules.libraries.logging.logs = {} -- table of logs

modules.libraries.logging.logtypes = {
    DEBUG = 1,
    INFO = 2,
    WARNING = 3,
    ERROR = 4,
} -- table of log types

modules.libraries.logging.loglevel = modules.libraries.logging.logtypes.DEBUG -- set the default log level to ERROR

modules.libraries.logging.loggingmode = "chat" -- set the default log mode to console

---@param logtype number
---@param title string
---@param message string
function modules.libraries.logging:log(logtype, title, message)
    local bundledlog = self:_bundleLog(self:_logLevelToString(logtype), title, message) -- bundle the log into a table for easy access
    local formattedlog = self:_formatLog(bundledlog) -- format the log into a string for easy access
    table.insert(self.logs, bundledlog) -- add the log to the logs table

    if self.loggingmode == "console" then
        debug.log(formattedlog) -- print the log to the console
    elseif self.loggingmode == "chat" and logtype >= self.loglevel then
        modules.libraries.chat:announce("Modules",formattedlog) -- print the log to the chat
    elseif self.loggingmode ~= "console" and self.loggingmode ~= "chat" then
        self:error("Logging", "Invalid logging mode: " .. self.loggingmode) -- print an error to the console
    end
end

-- bundle the log into a table for easy access
---@param logtype string
---@param title string
---@param message string
---@return table log
function modules.libraries.logging:_bundleLog(logtype, title, message)
    local log = {}
    log.type = logtype
    log.title = title
    log.message = message
    return log
end

-- format the log into a string for easy access
---@param log table
---@return string logstring
function modules.libraries.logging:_formatLog(log)
    local logstring = ""
    logstring = string.format("[%s] %s: %s",log.type,log.title,log.message)
    return logstring
end

-- turn the log level into a string for easy access
---@param loglevel number
function modules.libraries.logging:_logLevelToString(loglevel)
    if loglevel == self.logtypes.INFO then
        return "INFO"
    elseif loglevel == self.logtypes.WARNING then
        return "WARNING"
    elseif loglevel == self.logtypes.ERROR then
        return "ERROR"
    elseif loglevel == self.logtypes.DEBUG then
        return "DEBUG"
    else
        return "UNKNOWN"
    end
end

function modules.libraries.logging:setLogLevel(state)
    if state then
        state = state:upper() -- make the state lowercase
    else
        modules.libraries.logging:error("libraries.logging", "log level cannot be nil") -- print an error to the console
        return
    end
    if self.logtypes[state] then
        self.loglevel = self.logtypes[state] -- set the log level to the state
        self:info("libraries.logging", "Log level set to " .. state) -- print the log level to the console
    else
        self:error("libraries.logging", "Invalid log level: " .. state)
    end
end

---@param title string
---@param message string
function modules.libraries.logging:error(title, message)
    self:log(self.logtypes.ERROR, title, message)
end

---@param title string
---@param message string
function modules.libraries.logging:warning(title, message)
    self:log(self.logtypes.WARNING, title, message)
end

---@param title string
---@param message string
function modules.libraries.logging:info(title, message)
    self:log(self.logtypes.INFO, title, message)
end

---@param title string
---@param message string
function modules.libraries.logging:debug(title, message)
    self:log(self.logtypes.DEBUG, title, message)
end