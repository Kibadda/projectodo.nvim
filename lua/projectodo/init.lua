local M = {}

---@param user_config? ProjectodoConfig
function M.setup(user_config)
  require("projectodo.config").set(user_config)
end

---@param name ProjectodoProviderNames
function M.get_sections(name)
  local provider = require("projectodo.utils").get_provider(name)

  return provider:build()
end

return M
