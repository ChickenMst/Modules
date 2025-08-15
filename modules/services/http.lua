---@class HttpService: Service
---@field requests table<number, HttpRequest>
---@field groupedRequests table<number>
---@field counter number
---@field backendPort number
modules.services.http = modules.services:createService("http", "Service for handling HTTP requests", {"ChickenMst"})

function modules.services.http:initService()
    self.requests = {} -- table to store HTTP requests
    self.groupedRequests = {} -- table to store grouped requests
    self.counter = 0 -- counter for request IDs
    self.backendPort = modules.libraries.settings:getValue("backendPort",true, 8080) -- default backend port
end

function modules.services.http:startService()
    modules.libraries.callbacks:connect("httpReply", function(port, request, reply)
        if port == 0 then
            return
        end
        local requestId = self:_deformatToId(request)
        if requestId == nil then
            local grouped = self:_deformatGrouped(request)
            if type(modules.libraries.json:decode(reply)) == "table" then
                reply = modules.libraries.json:decode(reply)
            end
            for _, requested in pairs(grouped) do
                if self.requests[requested.id] then
                    modules.libraries.logging:debug("httpReply", "Received reply for grouped request ID: " .. tostring(requested.id))
                    for _, v in pairs(reply) do -- find the matching request ID in the grouped reply
                        if v.id == requested.id then
                            self.requests[requested.id]:func(v) -- call the callback function with the reply
                        end
                    end
                else
                    modules.libraries.logging:warning("httpReply", "Grouped request ID: " .. tostring(requested.id) .. " not found in requests table")
                end
            end
        else
            modules.libraries.logging:debug("httpReply", "Received reply for request ID: " .. tostring(requestId) .. ": " .. reply)
            self.requests[requestId]:func(reply) -- call the callback function with the reply
        end
    end)

    modules.libraries.callbacks:connect("onTick", function(game_ticks)
        if #self.groupedRequests ~= 0 then
            local group = self.groupedRequests

            local formatedRequest = self:_formatGrouped(group)

            server.httpGet(self.backendPort, formatedRequest) -- send the grouped request

            modules.libraries.logging:debug("onTick", "Sent grouped request: "..formatedRequest)

            self.groupedRequests = {} -- clear the grouped requests after sending
        end
    end)
end

function modules.services.http:get(port, url, callback, groupedRequest)
    -- Increment the counter for a new request ID
    self.counter = self.counter + 1
    local requestId = self.counter

    -- Store the request and its callback
    self.requests[requestId] = modules.classes.httpRequest:create(url, port, requestId, callback)

    if groupedRequest then
        table.insert(self.groupedRequests, requestId)

        modules.libraries.logging:debug("http:get", "Request with ID: " .. tostring(requestId) .. " has been saved to be sent as a grouped request")
    else
        local formatedRequest = self:_format(self.requests[requestId])

        -- Send the HTTP request
        server.httpGet(port, formatedRequest)

        modules.libraries.logging:debug("http:get", "Sent request with ID: " .. tostring(requestId) .. " to port: " .. tostring(port) .. " with URL: " .. url .. " formated to: "..formatedRequest)

        return self.requests[requestId]
    end
end

function modules.services.http:_format(request)
    -- Format the request for sending
    local striped = modules.libraries.table:strip(request, "function")
    local jsonRequest = modules.libraries.json:encode(striped)
    modules.libraries.logging:debug("http:_format", "Formatted request: " .. jsonRequest)
    return "/api/http/get?request="..jsonRequest
end

function modules.services.http:_formatGrouped(requestIds)
    local requests = {}
    for _, requestId in pairs(requestIds) do
        local request = self.requests[requestId]
        if request then
            table.insert(requests, modules.libraries.table:strip(request, "function"))
            modules.libraries.logging:debug("onTick", "Grouped request ID: " .. tostring(requestId) .. " preped for sending")
        else
            modules.libraries.logging:warning("onTick", "Request ID: " .. tostring(requestId) .. " not found in requests table")
        end
    end

    if #requests > 0 then
        local formatedRequest = modules.libraries.json:encode(requests)
        return "/api/http/group?request=" .. formatedRequest
    end
end

function modules.services.http:_deformatToId(formatedRequest)
    local request = string.gsub(formatedRequest, "/api/http/get%?request=", "")
    modules.libraries.logging:debug("http:_deformatToId", "Deformatted request: " .. request)
    request = modules.libraries.json:decode(request)
    return request and request.id or nil
end

function modules.services.http:_deformatGrouped(groupedRequest)
    local request = string.gsub(groupedRequest, "/api/http/group%?request=", "")
    modules.libraries.logging:debug("http:_deformatGrouped", "Deformatted grouped request: " .. request)
    request = modules.libraries.json:decode(request)
    if type(request) == "table" then
        return request
    end
end