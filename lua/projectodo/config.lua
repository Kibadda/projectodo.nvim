local M = {}

function M.defaults()
  ---@class ProjectodoConfig
  local defaults = {
    ---@type "vim-startify"|"mini-starter"
    plugin = "vim-startify",
    notes = {
      dir = "$HOME/notes",
      header = "Current projects",
      main = "index",
      ---@type "norg"
      extension = "norg",
    },
    sessions = vim.fn.stdpath "data" .. "/session",
    projects = {
      max = 6,
      todos = 9,
    },
    main_section = {
      name = "Main Section",
      sessions = {},
      has_create_command = true,
    },
    log = vim.fn.stdpath "state" .. "/projectodo.log",
  }
  return defaults
end

---@type ProjectodoConfig
M.options = {}

function M.set(user_config)
  M.options = vim.tbl_deep_extend("force", M.defaults(), user_config or {})
end

return M
