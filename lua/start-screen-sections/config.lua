local M = {}

local config = {
  plugin = "vim-startify",
  sessions = "$HOME/.local/share/nvim/session",
  notes = "$HOME/notes",
  max_projects = 6,
  max_todos_per_project = 9,
  norg_project_header = "Current Projects",
  norg_main_file = "index",
  main_section = {
    name = "Main Section",
    sessions = {},
  },
}

function M.set(user_config)
  config = vim.tbl_deep_extend("force", config, user_config or {})
end

function M.get(key)
  return config[key]
end

return M
