modules.services.vehicles = {} -- table of vehicle services

modules.services.vehicles.loadingVehicles = {} -- table of vehicles
modules.services.vehicles.loadedVehicles = {}

modules.libraries.callbacks:connect("onVehicleSpawn", function(vehicle_id, peer_id, x, y, z, group_cost, group_id)
    local vGroup = modules.services.vehicles.loadingVehicles[group_id]

    if vGroup then
        if not vGroup.vehicles[vehicle_id] then
            local vehicle = modules.classes.vehicle:create(vehicle_id, group_id)
            vGroup:addVehicle(vehicle)
            return
        end
        return
    end

    -- if the vehicle group doesn't exist, create it
    vGroup = modules.classes.vehicleGroup:create(group_id, peer_id)
    local vehicle = modules.classes.vehicle:create(vehicle_id, group_id)
    vGroup:addVehicle(vehicle)
end)

modules.libraries.callbacks:connect("onVehicleLoad", function(vehicle_id)
    local vdata = server.getVehicleData(vehicle_id)

    local vGroup = modules.services.vehicles.loadingVehicles[vdata.group_id]
    if not vGroup then
        modules.libraries.logging:error("services.vehicles", "Vehicle group not found for vehicle id: " .. vehicle_id)
        return
    end
    vGroup.vehicles[vehicle_id]:loaded()

    for _, vehicle in pairs(vGroup.vehicles) do
        if not vehicle.isLoaded then
            return
        end
    end

    vGroup:loaded()
    modules.services.vehicles.loadedVehicles[vdata.group_id] = vGroup
    modules.services.vehicles.loadingVehicles[vdata.group_id] = nil
end)

modules.libraries.callbacks:connect("onVehicleDespawn", function(vehicle_id, peer_id)
    local vdata = server.getVehicleData(vehicle_id)

    local vGroup = modules.services.vehicles.loadedVehicles[vdata.group_id]
    if not vGroup then
        modules.libraries.logging:error("services.vehicles", "Vehicle group not found for vehicle id: " .. vehicle_id)
        return
    end

    if vGroup.vehicles[vehicle_id] then
        vGroup.vehicles[vehicle_id]:despawned()
        vGroup.vehicles[vehicle_id] = nil
    end

    if vGroup.vehicles == {} then
        vGroup:despawned()
        modules.services.vehicles.loadedVehicles[vdata.group_id] = nil
    end
end)