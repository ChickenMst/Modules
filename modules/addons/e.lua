modules.onServiceInit:connect(function()
    local addon = modules.services.addon:createAddon("e",1,"Addon e",{"ChickenMst"})

    function addon:initAddon()
    end

    function addon:startAddon()
        self:addConnection(modules.libraries.callbacks:connect("onChatMessage", function(peer_id, sender_name, message)
            if message == "e" then
                modules.libraries.logging:info("e()", "Player: " .. sender_name .. " sent a message: " .. message)
            end
        end))

        self:addCommand(modules.services.command:create("e", {"ee"}, {}, "e", function(player, full_message, command, args)
            modules.libraries.logging:info("e()", "Player: " .. player.peerId .. " sent a command: " .. command)
        end))

        self:addCommand(modules.services.command:create("d", {"disable"}, {}, "disable e addon", function(player, full_message, command, args)
            modules.libraries.logging:info("disable()", "disableing self")
            modules.services.addon:disable(self.name)
        end))
    end
end)