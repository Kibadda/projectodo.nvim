---@class ProjectodoSection
---@field title string
---@field items ProjectodoItem[]
local Section = {}

---@param title string
---@param items ProjectodoItem[]
function Section:create(title, items)
  assert(title, "ProjectodoSection: title must be specified")

  self.__index = self
  return setmetatable({
    title = title,
    items = items,
  }, self)
end

return Section
