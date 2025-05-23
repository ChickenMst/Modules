modules.classes.vehicle = {} -- table of vehicle functions

function modules.classes.vehicle:create(groupid, vehicles, owner, spawnTime)
    ---@class VehicleGroup
    local vehicleGroup = {
        groupid = groupid,
        vehicles = vehicles,
        owner = owner,
        spawnTime = spawnTime,
        onDespawn = modules.libraries.events:create(),
        onLoaded = modules.libraries.events:create(),
    }

    function vehicleGroup:despawned(is_instant)
        self.onDespawn:fire(self)
    end

    function vehicleGroup:loaded()
        self.onLoaded:fire(self)
    end

    function vehicleGroup:setOwner(newowner)
        self.owner = newowner
    end

    function vehicleGroup:addVehicle(vehicle)
        if not self.vehicles[vehicle.id] then
            self.vehicles[vehicle.id] = vehicle
        end
    end

    return vehicleGroup
end