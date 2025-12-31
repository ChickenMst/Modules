modules.classes.widgets.color = {}

---@param r number|nil the red value (0-255) defaults to 255
---@param g number|nil the green value (0-255) defaults to 255
---@param b number|nil the blue value (0-255) defaults to 255
---@param a number|nil the alpha value (0-255) defaults to 255
---@return Color
function modules.classes.widgets.color:create(r, g, b, a)
    ---@class Color
    ---@field r number
    ---@field g number
    ---@field b number
    ---@field a number
    local color = {
        _class = "Color",
        r = r or 255,
        g = g or 255,
        b = b or 255,
        a = a or 255,
    }

    return color
end