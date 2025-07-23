require "modules"

counter = 0

requests = {}
replys = {}

modules.onStart:once(function()
	modules.services.command:create("httptest",{"ht"},{},"test http",function (player, full_message, command, args, hasPerm)
		counter = counter + 1
		local requestTbl = {
			num=counter,
			action="send",
			args=args
		}
		local request = modules.libraries.json:encode(requestTbl)
		server.httpGet(800,request)
		requests[counter] = requestTbl
	end)
end)

modules.libraries.callbacks:connect("httpReply", function(port, request, reply)
	request = modules.libraries.json:decode(request)
	local foundrequest = requests[request.num]
	replys[request.num] = reply
end)

modules.onStart:once(function()
	if modules.addonReason == "create" then
		modules.libraries.logging:info("onCreate()", "World created")
	elseif modules.addonReason == "reload" then
		modules.libraries.logging:info("onCreate()", "Script reloaded")
	elseif modules.addonReason == "load" then
		modules.libraries.logging:info("onCreate()", "World loaded")
	else
		modules.libraries.logging:info("onCreate()", "Unknown world state: " .. tostring(modules.addonReason))
	end
end)