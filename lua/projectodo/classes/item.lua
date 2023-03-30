---@class ProjectodoItem
---@field title string
---@field action ?function|string
local Item = {}

---@param title string
---@param action ?function
function Item:create(title, action)
  assert(title, "ProjectodoItem: title must be specified")

  self.__index = self
  return setmetatable({
    title = title,
    action = action or "",
  }, self)
end

return Item
