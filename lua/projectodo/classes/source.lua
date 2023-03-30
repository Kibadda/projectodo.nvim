---@class ProjectodoSource
---@field load (fun(self: ProjectodoSource))
---@field get (fun(self: ProjectodoSource): ProjectodoSection[])
---@field open function
---@field data ProjectodoSection[]
---@field config ProjectodoConfigGitlab|ProjectodoConfigTreesitter|ProjectodoConfigSession
local Source = {}

---@param name "gitlab"|"treesitter"|"session"
---@return ProjectodoSource
function Source:create(name)
  local options = require("projectodo.config").options
  local config
  if name == "gitlab" then
    config = options.sources.gitlab
  elseif name == "treesitter" then
    config = options.sources.treesitter
  elseif name == "session" then
    config = options.sources.session
  end
  self.__index = self
  return setmetatable({
    config = config,
    data = {},
  }, self)
end

function Source:load()
  self.data = {}
end

function Source:get()
  return self.data
end

function Source:open() end

return Source
