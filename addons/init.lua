---@require_dir .
require("addons.e")
require("addons.test")
---@require_dir_end

return {
    ---@require_dir_fields .
    ["e"] = require("addons.e"),
    ["test"] = require("addons.test"),
    ---@require_dir_end
}