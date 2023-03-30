local M = {}

function M.defaults()
  ---@class ProjectodoConfig
  local defaults = {
    sources = {
      ---@class ProjectodoConfigGitlab
      gitlab = {
        enabled = false,
        uses_session = false,
        url = "",
        access_token = "GITLAB_ACCESS_TOKEN",
        ---@type number
        project_id = nil,
        labels = {},
        cache = vim.fn.stdpath "cache" .. "/projectodo.json",
        force = false,
      },
      ---@class ProjectodoConfigTreesitter
      treesitter = {
        enabled = false,
        uses_session = false,
        dir = "",
        header = "",
        main = "",
      },
      ---@class ProjectodoConfigSession
      session = {
        enabled = false,
        dir = vim.fn.stdpath "data" .. "/session",
      },
    },
  }
  return defaults
end

M.options = M.defaults()

---@param user_config? ProjectodoConfig
function M.set(user_config)
  M.options = vim.tbl_deep_extend("force", M.defaults(), user_config or {})
end

return M
