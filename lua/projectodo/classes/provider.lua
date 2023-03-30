---@class ProjectodoProvider
---@field build (fun(self: ProjectodoSource): table)
---@field _config ProjectodoConfig
local Provider = {}

---@return ProjectodoProvider
function Provider:create()
  self.__index = self
  return setmetatable({
    _config = require("projectodo.config").options,
  }, self)
end

function Provider:build()
  return {}
end

return Provider
