local M = {}

---@return table<string, ProjectodoSource>
function M.get_sources()
  local config = require "projectodo.config"

  local sources = {}
  for name, source in pairs(config.options.sources) do
    if source.enabled then
      sources[name] = require("projectodo.sources." .. name)
    end
  end

  return sources
end

---@enum ProjectodoProviderNames
local providers = {
  MINI_STARTER = "mini-starter",
}

local function is_supported(name)
  local support = false
  for _, id in pairs(providers) do
    if id == name then
      support = true
      break
    end
  end
  return support
end

---@param name ProjectodoProviderNames
---@return ProjectodoProvider
function M.get_provider(name)
  assert(is_supported(name), "This provider is not supported")
  return require("projectodo.providers." .. name)
end

return M
