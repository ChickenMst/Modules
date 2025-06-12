local addon = modules.classes.addon:create("e",1,"aussieworks","Addon e")

function addon:init()
    self:addConnection(modules.libraries.callbacks:connect("onChatMessage", function(peer_id, sender_name, message)
        if message == "e" then
            modules.libraries.logging:info("e()", "Player: " .. sender_name .. " sent a message: " .. message)
        end
    end))

    self:addCommand(modules.libraries.commands:create("e", {"ee"}, "e", function(full_message, peer_id, is_admin, is_auth, command, ...)
        modules.libraries.logging:info("e()", "Player: " .. peer_id .. " sent a command: " .. command)
    end))

    return false
end

modules.services.addons:connect("e", addon) -- connect the addon to the addons table