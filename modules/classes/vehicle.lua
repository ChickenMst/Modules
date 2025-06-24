modules.classes.vehicle = {} -- table of vehicle functions

---@param vehicleId number
---@param groupId number|string
---@param loaded boolean|nil
---@return Vehicle
function modules.classes.vehicle:create(vehicleId, groupId, loaded)
    ---@class Vehicle
    local vehicle = {
        id = vehicleId,
        groupId = tostring(groupId),
        onDespawn = modules.libraries.event:create(),
        onLoaded = modules.libraries.event:create(),
        isLoaded = loaded or false,
        isDespawned = false
    }

    function vehicle:despawned(is_instant)
        self.isDespawned = true
        self.onDespawn:fire(self)
    end

    function vehicle:loaded()
        self.onLoaded:fire(self)
        self.isLoaded = true
    end

    return vehicle
end