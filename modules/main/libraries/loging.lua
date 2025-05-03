modules.main.libraries.logging = {} -- table of loging functions

modules.main.libraries.logging.logs = {} -- table of loging functions

modules.main.libraries.logging.logtypes = {
    INFO = "INFO",
    WARNING = "WARNING",
    ERROR = "ERROR",
    DEBUG = "DEBUG",
} -- table of log types

modules.main.libraries.logging.loglevel = modules.main.libraries.logging.logtypes.ERROR -- set the default log level to ERROR

modules.main.libraries.logging.loggingmode = "chat" -- set the default log mode to console

---@param logtype string
---@param title string
---@param message string
function modules.main.libraries.logging:log(logtype, title, message)
    local bundledlog = self:_bundleLog(logtype, title, message) -- bundle the log into a table for easy access
    local formattedlog = self:_formatLog(bundledlog) -- format the log into a string for easy access
    table.insert(self.logs, bundledlog) -- add the log to the logs table
    
    if self.logingmode == "console" then
        debug.log(formattedlog) -- print the log to the console
    elseif self.logingmode == "chat" then
        modules.main.libraries.chat:announce("[Server]: Auscode",formattedlog) -- print the log to the chat
    else
        self:error("Loging", "Invalid loging mode: " .. self.logingmode) -- print an error to the console
    end
end

-- bundle the log into a table for easy access
---@param logtype string
---@param title string
---@param message string
---@return table log
function modules.main.libraries.logging:_bundleLog(logtype, title, message)
    local log = {}
    log.type = logtype
    log.title = title
    log.message = message
    return log
end

-- format the log into a string for easy access
---@param log table
---@return string logstring
function modules.main.libraries.logging:_formatLog(log)
    local logstring = ""
    logstring = logstring .. "[" .. log.type .. "] " .. log.title .. ": " .. log.message
    return logstring
end

---@param title string
---@param message string
function modules.main.libraries.logging:error(title, message)
    self:log(self.logtypes.ERROR, title, message)
end

---@param title string
---@param message string
function modules.main.libraries.logging:warning(title, message)
    self:log(self.logtypes.WARNING, title, message)
end

---@param title string
---@param message string
function modules.main.libraries.logging:info(title, message)
    self:log(self.logtypes.INFO, title, message)
end

---@param title string
---@param message string
function modules.main.libraries.logging:debug(title, message)
    self:log(self.logtypes.DEBUG, title, message)
end