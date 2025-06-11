modules.services.vehicles = {} -- table of vehicle services

modules.services.vehicles.loadingVehicles = {} ---@type table <number, VehicleGroup> -- table of vehicles
modules.services.vehicles.loadedVehicles = {} ---@type table <number, VehicleGroup>

modules.libraries.callbacks:once("onCreate", function(is_world_create)
    if modules.addonReason == "reload" then
        modules.services.vehicles:_load() -- load the service on creation
    end
end)

modules.libraries.callbacks:connect("onVehicleSpawn", function(vehicle_id, peer_id, x, y, z, group_cost, group_id)
    group_id = tostring(group_id)
    local vGroup = modules.services.vehicles.loadingVehicles[group_id]

    if not vGroup then
        vGroup = modules.classes.vehicleGroup:create(group_id, modules.services.player:getPlayerByPeer(peer_id))
    end

    if not vGroup.vehicles[vehicle_id] then
        local vehicle = modules.classes.vehicle:create(vehicle_id, group_id)
        vGroup:addVehicle(vehicle)
    end

    modules.libraries.logging:debug("onVehicleSpawn", "Vehicle spawned with id: " .. vehicle_id .. ", group id: " .. group_id)
    modules.services.vehicles.loadingVehicles[group_id] = vGroup
    modules.services.vehicles:_save()
end)

modules.libraries.callbacks:connect("onVehicleLoad", function(vehicle_id)
    local vdata = server.getVehicleData(vehicle_id)

    local vGroup = modules.services.vehicles.loadingVehicles[tostring(vdata.group_id)]
    if not vGroup then
        modules.libraries.logging:info("onVehicleLoad", "Vehicle group not found for vehicle id: " .. vehicle_id)
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
        modules.services.vehicles.loadedVehicles[tostring(vdata.group_id)] = vGroup
        modules.services.vehicles.loadingVehicles[tostring(vdata.group_id)] = nil
        modules.services.vehicles:_save()
    end
end)

modules.libraries.callbacks:connect("onVehicleDespawn", function(vehicle_id, peer_id)
    local vdata = server.getVehicleData(vehicle_id)

    local vGroup = modules.services.vehicles.loadedVehicles[tostring(vdata.group_id)]
    if not vGroup then
        modules.libraries.logging:info("onVehicleDespawn()", "Vehicle group not found for vehicle id: " .. vehicle_id)
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
        modules.services.vehicles.loadedVehicles[tostring(vdata.group_id)] = nil
        modules.services.vehicles:_save()
    end
end)

function modules.services.vehicles:_save()
    modules.libraries.gsave:saveService("vehicles", self)
end

function modules.services.vehicles:_load()
    local service = modules.libraries.gsave:loadService("vehicles")

    if not service then
        modules.libraries.logging:warning("vehicles:_load", "Skiped loading vehicles service, no data found.")
        return
    end

    if service.loadingVehicles then
        local rebuilt = {} -- table to rebuild loading vehicles
        for _,vGroup in pairs(service.loadingVehicles) do
            local rebuiltGroup = modules.classes.vehicleGroup:create(vGroup.group_id, modules.services.player:getPlayer(vGroup.owner.steamId), vGroup.spawnTime)
            for _, vehicle in pairs(vGroup.vehicles) do
                local rebuiltVehicle = modules.classes.vehicle:create(vehicle.id, vGroup.group_id, vehicle.isLoaded)
                rebuiltGroup:addVehicle(rebuiltVehicle)
            end
            rebuilt[vGroup.group_id] = rebuiltGroup
        end
        self.loadingVehicles = rebuilt
    end

    if service.loadedVehicles then
        local rebuilt = {} -- table to rebuild loading vehicles
        for _,vGroup in pairs(service.loadedVehicles) do
            local rebuiltGroup = modules.classes.vehicleGroup:create(vGroup.group_id, modules.services.player:getPlayer(vGroup.owner.steamId), vGroup.spawnTime, vGroup.isLoaded)
            for _, vehicle in pairs(vGroup.vehicles) do
                local rebuiltVehicle = modules.classes.vehicle:create(vehicle.id, vGroup.group_id, vehicle.isLoaded)
                rebuiltGroup:addVehicle(rebuiltVehicle)
            end
            rebuilt[vGroup.group_id] = rebuiltGroup
        end
        self.loadedVehicles = rebuilt
    end
end