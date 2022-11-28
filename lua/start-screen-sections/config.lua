local M = {}

local config = {
  plugin = nil,
  notes_project_header = nil,
  sessions = "$HOME/.local/share/nvim/session",
  notes = "$HOME/notes",
  max_projects = 6,
  max_todos_per_project = 9,
  notes_main_file = "index",
  notes_extension = "norg",
  main_section = {
    name = "Main Section",
    sessions = {},
  },
}

local function one_of(available, optional)
  return function(value)
    if optional and value == nil then
      return true
    end
    return vim.tbl_contains(available, value), ("one of: %s"):format(table.concat(available, ", "))
  end
end

local function is_directory()
  return function(path)
    if path == nil then
      return true
    end

    return vim.fn.isdirectory(vim.fn.expand(path)) == 1, ("'%s' is not a directory"):format(path)
  end
end

local function gte(limit)
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
    plugin = { user_config.plugin, one_of({ "vim-startify", "alpha-nvim", "mini-starter" }, false), "plugin" },
    notes_project_header = { user_config.notes_project_header, "string" },
    sessions = { user_config.sessions, is_directory(), "sessions directory" },
    notes = { user_config.notes, is_directory(), "notes directory" },
    max_projects = { user_config.max_projects, gte(1), "maximum projects on screen" },
    max_todos_per_project = { user_config.max_todos_per_project, gte(0), "maximum todos per project on screen" },
    notes_main_file = { user_config.notes_main_file, "string", true },
    notes_extension = { user_config.extension, one_of({ "norg" }, true), "extension" },
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

function M.get_notes_extension()
  return config.notes_extension
end

function M.get_main_section()
  return config.main_section
end

return M
