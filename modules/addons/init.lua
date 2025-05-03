-- init addons table
modules.addons = {}


modules.addons.createdAddons = {} -- table of created addons
modules.addons.loadedAddons = {} -- table of addons that are actively loaded

-- functions to load and run addons

-- add addon into the main addon table
---@param name string
---@param func function
---@return nil
---@usage modules.addons:Create("name", function() end)
function modules.addons:Create(name, func)
    if not self.createdAddons[name] then
        -- init addon table if it doesn't exist
        self.createdAddons[name] = {}
    end

    if type(func) == "function" then
        -- check that the addon function is a function
        table.insert(self.createdAddons[name], func)
    else
        debug.log("Addon function must be a function")
    end
end

-- tick addons tick function
function modules.addons:TickAddons()
end