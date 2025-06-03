modules.services.vehicles = {} -- table of vehicle services

modules.services.vehicles.loadingVehicles = {} ---@type table <number, VehicleGroup> -- table of vehicles
modules.services.vehicles.loadedVehicles = {} ---@type table <number, VehicleGroup>

modules.libraries.callbacks:once("onCreate", function()
    modules.services.vehicles = modules.libraries.gsave:loadService("vehicles") or modules.services.vehicles
end)

modules.libraries.callbacks:connect("onVehicleSpawn", function(vehicle_id, peer_id, x, y, z, group_cost, group_id)
    local vGroup = modules.services.vehicles.loadingVehicles[group_id]

    if not vGroup then
        vGroup = modules.classes.vehicleGroup:create(group_id, peer_id)
    end

    if not vGroup.vehicles[vehicle_id] then
        local vehicle = modules.classes.vehicle:create(vehicle_id, group_id)
        vGroup:addVehicle(vehicle)
    end

    modules.libraries.logging:debug("onVehicleSpawn", "Vehicle spawned with id: " .. vehicle_id .. ", group id: " .. group_id)
    modules.services.vehicles.loadingVehicles[group_id] = vGroup
    modules.libraries.gsave:saveService("vehicles", modules.services.vehicles)
end)

modules.libraries.callbacks:connect("onVehicleLoad", function(vehicle_id)
    local vdata = server.getVehicleData(vehicle_id)

    local vGroup = modules.services.vehicles.loadingVehicles[vdata.group_id]
    if not vGroup then
        modules.libraries.logging:error("onVehicleLoad", "Vehicle group not found for vehicle id: " .. vehicle_id)
        return
    end
    vGroup.vehicles[vehicle_id]:loaded()

    local loaded = true
    for _, vehicle in pairs(vGroup.vehicles) do
        if not vehicle.isLoaded then
            loaded = false
        end
    end

    if loaded then
        modules.libraries.logging:debug("onVehicleLoad", "Vehicle group loaded with id: " .. vGroup.group_id)
        vGroup:loaded()
        modules.services.vehicles.loadedVehicles[vdata.group_id] = vGroup
        modules.services.vehicles.loadingVehicles[vdata.group_id] = nil
        modules.libraries.gsave:saveService("vehicles", modules.services.vehicles)
    end
end)

modules.libraries.callbacks:connect("onVehicleDespawn", function(vehicle_id, peer_id)
    local vdata = server.getVehicleData(vehicle_id)

    local vGroup = modules.services.vehicles.loadedVehicles[vdata.group_id]
    if not vGroup then
        modules.libraries.logging:error("onVehicleDespawn()", "Vehicle group not found for vehicle id: " .. vehicle_id)
        return
    end

    if vGroup.vehicles[vehicle_id] then
        modules.libraries.logging:debug("onVehicleDespawn", "Vehicle despawned with id: " .. vehicle_id .. ", group id: " .. vGroup.group_id)
        vGroup.vehicles[vehicle_id]:despawned()
        vGroup.vehicles[vehicle_id] = nil
    end

    local despawned = true
    for _, vehicle in pairs(vGroup.vehicles) do
        if not vehicle.isDespawned then
            despawned = false
        end
    end

    if despawned then
        modules.libraries.logging:debug("onVehicleDespawn", "Vehicle group despawned with id: " .. vGroup.group_id)
        vGroup:despawned()
        modules.services.vehicles.loadedVehicles[vdata.group_id] = nil
        modules.libraries.gsave:saveService("vehicles", modules.services.vehicles)
    end
end)