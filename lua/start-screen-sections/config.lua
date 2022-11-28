local M = {}

local config = {
  plugin = nil,
  notes_project_header = nil,
  sessions = "$HOME/.local/share/nvim/session",
  notes = "$HOME/notes",
  max_projects = 6,
  max_todos_per_project = 9,
  notes_main_file = "index",
  main_section = {
    name = "Main Section",
    sessions = {},
  },
}

local function check_plugin()
  return function(plugin)
    local available_plugins = { "vim-startify", "alpha-nvim", "mini-starter" }

    return vim.tbl_contains(available_plugins, plugin), ("one of: %s"):format(table.concat(available_plugins, ", "))
  end
end

local function check_directory()
  return function(path)
    if path == nil then
      return true
    end

    return vim.fn.isdirectory(vim.fn.expand(path)) == 1, ("'%s' is not a directory"):format(path)
  end
end

local function check_number(limit)
  return function(number)
    if number == nil then
      return true
    end

    return number >= limit, ("must be greater than or equal to %d"):format(limit)
  end
end

function M.set(user_config)
  user_config = user_config or {}

  vim.validate {
    config = { user_config, "table" },
  }

  vim.validate {
    plugin = { user_config.plugin, check_plugin(), "plugin" },
    notes_project_header = { user_config.notes_project_header, "string" },
    sessions = { user_config.sessions, check_directory(), "sessions directory" },
    notes = { user_config.notes, check_directory(), "notes directory" },
    max_projects = { user_config.max_projects, check_number(1), "maximum projects on screen" },
    max_todos_per_project = {
      user_config.max_todos_per_project,
      check_number(0),
      "maximum todos per project on screen",
    },
    notes_main_file = { user_config.notes_main_file, "string", true },
    main_section = { user_config.main_section, "table", true },
  }

  if user_config.main_section ~= nil then
    vim.validate {
      name = { user_config.main_section.name, "string", true },
      sessions = { user_config.main_section.sessions, "table", true },
    }
  end

  config = vim.tbl_deep_extend("force", config, user_config or {})
end

function M.get_plugin()
  return config.plugin
end

function M.get_notes_project_header()
  return config.notes_project_header
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

function M.get_notes_main_file()
  return config.notes_main_file
end

function M.get_main_section()
  return config.main_section
end

return M
