local M = {}

local config = {
  plugin = "vim-startify",
  sessions = "$HOME/.local/share/nvim/session",
  notes = "$HOME/notes",
  max_projects = 6,
  max_todos_per_project = 9,
  notes_project_header = "Current Projects",
  notes_main_file = "index",
  main_section = {
    name = "Main Section",
    sessions = {},
  },
}

function M.set(user_config)
  config = vim.tbl_deep_extend("force", config, user_config or {})
end

function M.get_plugin()
  return config.plugin
end

function M.get_sessions()
  return config.sessions
end

function M.get_notes()
  return config.notes
end

function M.get_max_projects()
  return config.max_projects
end

function M.get_max_todos_per_project()
  return config.max_todos_per_project
end

function M.get_notes_project_header()
  return config.notes_project_header
end

function M.get_notes_main_file()
  return config.notes_main_file
end

function M.get_main_section()
  return config.main_section
end

return M
