---@class vehicleService: Service
---@field loadingVehicles table<number, VehicleGroup> -- table of vehicles that are being loaded
---@field loadedVehicles table<number, VehicleGroup> -- table of vehicles that are loaded
modules.services.vehicle = modules.services:createService("vehicles", "Handles vehicle spawning, loading, and despawning.", {"ChickenMst"})

function modules.services.vehicle:initService()
    self.loadingVehicles = {}
    self.loadedVehicles = {}
end

function modules.services.vehicle:startService()
    if modules.addonReason == "reload" then
        self:_load() -- load the service on creation
    end

    modules.libraries.callbacks:connect("onVehicleSpawn", function(vehicle_id, peer_id, x, y, z, group_cost, group_id)
        group_id = tostring(group_id)
        local vGroup = self.loadingVehicles[group_id]

        if not vGroup then
            vGroup = modules.classes.vehicleGroup:create(group_id, modules.services.player:getPlayerByPeer(peer_id))
        end

        if not vGroup.vehicles[vehicle_id] then
            local vehicle = modules.classes.vehicle:create(vehicle_id, group_id)
            vGroup:addVehicle(vehicle)
        end

        modules.libraries.logging:debug("onVehicleSpawn", "Vehicle spawned with id: " .. vehicle_id .. ", group id: " .. group_id)
        self.loadingVehicles[group_id] = vGroup
        self:_save()
    end)

    modules.libraries.callbacks:connect("onVehicleLoad", function(vehicle_id)
        local vdata = server.getVehicleData(vehicle_id)

        local vGroup = self.loadingVehicles[tostring(vdata.group_id)]
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
            self.loadedVehicles[tostring(vdata.group_id)] = vGroup
            self.loadingVehicles[tostring(vdata.group_id)] = nil
            self:_save()
        end
    end)

    modules.libraries.callbacks:connect("onVehicleDespawn", function(vehicle_id, peer_id)
        local vdata = server.getVehicleData(vehicle_id)

        local vGroup = self.loadedVehicles[tostring(vdata.group_id)]
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
            self.loadedVehicles[tostring(vdata.group_id)] = nil
            self:_save()
        end
    end)
end

function modules.services.vehicle:_save()
    modules.libraries.gsave:saveService("vehicles", self)
end

function modules.services.vehicle:_load()
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