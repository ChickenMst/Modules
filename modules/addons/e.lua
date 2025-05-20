local addon = modules.libraries.addons:create("e",1,"aussieworks","Addon e")

local addonfunc = {}

function addonfunc:init()
    modules.libraries.callbacks:connect("onChatMessage", function(peer_id, sender_name, message)
        if message == "e" then
            modules.libraries.logging:info("e()", "Player: " .. sender_name .. " sent a message: " .. message)
        end
    end)

    modules.libraries.commands:create("e", {"e"}, "e", function(full_message, peer_id, is_admin, is_auth, command, ...)
        modules.libraries.logging:info("e()", "Player: " .. peer_id .. " sent a command: " .. command)
    end)

    modules.libraries.commands:create("a", {"a"}, "ea", function(full_message, peer_id, is_admin, is_auth, command, ...)
        modules.libraries.logging:info("ea()", "Player: " .. peer_id .. " sent a command: " .. command)
    end)

    return true
end

addon:connect(addonfunc)

modules.libraries.addons:connect("e", addon) -- connect the addon to the addons table