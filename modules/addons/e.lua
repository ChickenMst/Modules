function modules.addons.e:print(...)
    local args = {...}
    local str = ""
    for i, v in ipairs(args) do
        str = str .. tostring(v) .. " "
    end
    debug.log(str)
end