-- init addons table
modules.addons = {}

---@require_dir .
require("modules.addons.e")
---@require_dir_end

return {
    ---@require_dir_fields .
    ["e"] = require("modules.addons.e"),
    ---@require_dir_end
}