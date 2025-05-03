modules.main.libraries.chat = {} -- table of chat functions

modules.main.libraries.chat.messages = {} -- table of chat messages

function modules.main.libraries.chat:announce(title, message, target)
    target = target or -1 -- set the target to all if not specified
    server.announce(title, message, target) -- send the message to the server
end