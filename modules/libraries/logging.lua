modules.libraries.logging = {} -- table of logging functions

modules.libraries.logging.logs = {} -- table of logs

modules.libraries.logging.logtypes = {
    INFO = "INFO",
    WARNING = "WARNING",
    ERROR = "ERROR",
    DEBUG = "DEBUG",
} -- table of log types

modules.libraries.logging.loglevel = modules.libraries.logging.logtypes.ERROR -- set the default log level to ERROR

modules.libraries.logging.loggingmode = "chat" -- set the default log mode to console

---@param logtype string
---@param title string
---@param message string
function modules.libraries.logging:log(logtype, title, message)
    local bundledlog = self:_bundleLog(logtype, title, message) -- bundle the log into a table for easy access
    local formattedlog = self:_formatLog(bundledlog) -- format the log into a string for easy access
    table.insert(self.logs, bundledlog) -- add the log to the logs table
    
    if self.loggingmode == "console" then
        debug.log(formattedlog) -- print the log to the console
    elseif self.loggingmode == "chat" then
        modules.libraries.chat:announce("[Server]: Auscode",formattedlog) -- print the log to the chat
    else
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
    logstring = logstring .. "[" .. log.type .. "] " .. log.title .. ": " .. log.message
    return logstring
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