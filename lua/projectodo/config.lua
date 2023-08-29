local M = {}

function M.defaults()
  ---@class ProjectodoConfig
  local defaults = {
    sources = {
      ---@class ProjectodoConfigGit
      git = {
        enabled = false,
        uses_session = false,
        url = "",
        access_token = "GITLAB_ACCESS_TOKEN",
        ---@type number
        project_id = nil,
        ignore_labels = {},
        ---@type string
        cache = vim.fn.stdpath "cache" .. "/projectodo.json",
        force = false,
        ---@type "gitlab"|"github"
        adapter = "gitlab",
        ---@type fun(issue: table): boolean
        filter = function(_)
          return true
        end,
      },
      ---@class ProjectodoConfigTreesitter
      treesitter = {
        enabled = false,
        uses_session = false,
        dir = "",
        header = "",
        main = "",
        ---@type "norg"
        filetype = "norg",
      },
      ---@class ProjectodoConfigSession
      session = {
        enabled = false,
        ---@type string
        dir = vim.fn.stdpath "data" .. "/session",
        ---@type fun(session: string): function
        load_action = nil,
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
