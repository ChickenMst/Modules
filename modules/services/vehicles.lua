modules.services.vehicles = {} -- table of vehicle services

modules.services.vehicles.loadingVehicles = {} -- table of vehicles
modules.services.vehicles.loadedVehicles = {}

modules.libraries.callbacks:connect("onVehicleLoad", function(vehicle_id)
    local vdata = server.getVehicleData(vehicle_id)

    local vGroup = modules.services.vehicles.loadingVehicles[vdata.group_id]
    if not vGroup then
        modules.libraries.logging:error("services.vehicles", "Vehicle group not found for vehicle id: " .. vehicle_id)
        return
    end
end)