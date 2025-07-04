modules.libraries.table = {}

-- https://github.com/cuhHub/Noir/blob/v2.0.0/src/Noir/Built-Ins/Libraries/Table.lua
function modules.libraries.table:tostring(tbl, indent)
    -- Set default indent
    if not indent then
        indent = 0
    end

    -- Create a table for later
    local toConcatenate = {}

    -- Convert the table to a string
    for index, value in pairs(tbl) do
        -- Get value type
        local valueType = type(value)

        -- Format the index for later
        local formattedIndex = ("[%s]:"):format(type(index) == "string" and "\""..index.."\"" or tostring(index):gsub("\n", "\\n"))

        -- Format the value
        local toAdd = formattedIndex

        if valueType == "table" then
            -- Format table
            local nextIndent = indent + 2
            local formattedValue = self:tostring(value, nextIndent)

            -- Check if empty table
            if formattedValue == "" then
                formattedValue = "{}"
            else
                formattedValue = "\n"..formattedValue
            end

            -- Add to string
            toAdd = toAdd..(" %s"):format(formattedValue)
        elseif valueType == "number" or valueType == "boolean" then
            toAdd = toAdd..(" %s"):format(tostring(value))
        else
            toAdd = toAdd..(" \"%s\""):format(tostring(value):gsub("\n", "\\n"))
        end

        -- Add to table
        table.insert(toConcatenate, ("  "):rep(indent)..toAdd)
    end

    -- Return the table as a formatted string
    return table.concat(toConcatenate, "\n")
end
