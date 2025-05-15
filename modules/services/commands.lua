modules.services.commands = {} -- table of command functions

modules.libraries.callbacks:connect("onCustomCommand", function(full_message, peer_id, is_admin, is_auth, command, ...)
    command = modules.libraries.commands:cleanCommandString(command)
    if modules.libraries.commands.commands[command] then
        modules.libraries.commands.commands[command]:run(full_message, peer_id, is_admin, is_auth, command, ...)
    elseif not modules.libraries.commands.commands[command] then
        for _, cmd in pairs(modules.libraries.commands.commands) do
            for _, alias in pairs(cmd.alias) do
                if alias == command then
                    cmd:run(full_message, peer_id, is_admin, is_auth, command, ...)
                    return
                end
            end
        end
        modules.libraries.logging:warning("services.commands", "Command not found: " .. command)
    end
end)