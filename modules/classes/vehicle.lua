modules.classes.vehicle = {} -- table of vehicle functions

function modules.classes.vehicle:create(vehicleId, groupId)
    ---@class Vehicle
    local vehicle = {
        id = vehicleId,
        groupId = groupId,
        onDespawn = modules.libraries.events:create(),
        onLoaded = modules.libraries.events:create(),
        isLoaded = false
    }

    function vehicle:despawned(is_instant)
        self.onDespawn:fire(self)
    end

    function vehicle:loaded()
        self.onLoaded:fire(self)
        self.isLoaded = true
    end

    return vehicle
end