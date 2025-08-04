---@class HttpService: Service
---@field requests table
---@field counter number
---@field backendPort number
modules.services.http = modules.services:createService("http", "Service for handling HTTP requests", {"ChickenMst"})

function modules.services.http:initService()
    self.requests = {} -- table to store HTTP requests
    self.counter = 0 -- counter for request IDs
    self.backendPort = modules.libraries.settings:getValue("backendPort",true, 8080) -- default backend port
end

function modules.services.http:startService()
    modules.libraries.callbacks:connect("httpReply", function(port, request, reply)
        if port ~= self.backendPort then
            return
        end
        local requestId = self:_deformatToId(request)
        modules.libraries.logging:debug("httpReply", "Received reply for request ID: " .. tostring(requestId) .. ": " .. reply)
        self.requests[requestId]:func(reply) -- call the callback function with the reply
    end)
end

function modules.services.http:get(port, url, callback)
    -- Increment the counter for a new request ID
    self.counter = self.counter + 1
    local requestId = self.counter

    -- Store the request and its callback
    self.requests[requestId] = modules.classes.httpRequest:create(url, port, requestId, callback)

    local formatedRequest = self:_format(self.requests[requestId])

    -- Send the HTTP request
    server.httpGet(port, formatedRequest)

    modules.libraries.logging:debug("http:get", "Sent request with ID: " .. tostring(requestId) .. " to port: " .. tostring(port) .. " with URL: " .. url .. " formated to: "..formatedRequest)

    return self.requests[requestId]
end

function modules.services.http:_format(request)
    -- Format the request for sending
    local striped = modules.libraries.table:strip(request, "function")
    local jsonRequest = "{\"request\":\""..striped.request.."\",\"id\":"..striped.id..",\"port\":"..striped.port.."}"
    modules.libraries.logging:debug("http:_format", "Formatted request: " .. jsonRequest)
    return "/api/http/get?request="..jsonRequest
end

function modules.services.http:_deformatToId(formatedRequest)
    local request = string.gsub(formatedRequest, "/api/http/get%?request=", "")
    request = modules.libraries.json:decode(request)
    return request and request.id or nil
end