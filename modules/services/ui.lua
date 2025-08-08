---@class UiService: Service
modules.services.ui = modules.services:createService("ui", "service for handling UI",{"ChickenMst"})

function modules.services.ui:_init()
    self.widgets = {} -- Store all UI widgets
end

function modules.services.ui:_start()
    modules.libraries.callbacks:connect("onPlayerJoin", function(steam_id, name, peer_id, is_admin, is_auth)
        
    end)
end

function modules.services.ui:getPlayersWidgets(player)
    
end