local M = {}

---@param user_config? ProjectodoConfig
function M.setup(user_config)
  require("projectodo.config").set(user_config)
end

function M.get_sections()
  return require("projectodo.sections").get_sections()
end

return M
