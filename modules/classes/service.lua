modules.classes.service = {}

function modules.classes.service:create(name, description, authors)
    local service = {
        name = name,
        description = description,
        authors = authors,

        hasInit = false,
        hasStarted = false
    }

    function service:_init()
        if self.hasInit then
            modules.libraries.logging:warning("service:_init()", "Service '" .. self.name .. "' is already initialized.")
            return
        end

        modules.libraries.logging:debug("service:_init()", "Initializing service '" .. self.name .. "'")
        self.hasInit = true

        if not self.initService then
            return
        end

        self:initService()
    end

    function service:_start()
        if self.hasStarted then
            modules.libraries.logging:warning("service:_start()", "Attempted to start service '" .. self.name .. "' that is already started.")
            return
        end

        if not self.hasInit then
            modules.libraries.logging:error("service:_start()", "Attempted to start service '" .. self.name .. "' that is not initialized.")
            return
        end

        self.hasStarted = true

        if not self.startService then
            return
        end

        self:startService()
    end

    return service
end