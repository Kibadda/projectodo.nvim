local M = {}

local config = {
  plugin = "vim-startify",
  sessions = "$HOME/.local/share/nvim/session",
  notes = "$HOME/notes",
  max_projects = 6,
  max_todos_per_project = 9,
  notes_project_header = nil,
  notes_main_file = "index",
  main_section = {
    name = "Main Section",
    sessions = {},
  },
}

function M.set(user_config)
  user_config = user_config or {}

  vim.validate {
    config = { user_config, "table" },
  }

  vim.validate {
    plugin = {
      user_config.plugin,
      function(value)
        if not value then
          return true
        end
        local available_plugins = { "vim-startify", "alpha-nvim", "mini-starter" }

        return vim.tbl_contains(available_plugins, value), ("one of: %s"):format(table.concat(available_plugins, ", "))
      end,
      "plugin name",
    },
    sessions = {
      user_config.sessions,
      function(value)
        if not value then
          return true
        end
        return vim.fn.isdirectory(vim.fn.expand(value)) == 1, ("'%s' is not a directory"):format(value)
      end,
      "sessions directory",
    },
    notes = {
      user_config.notes,
      function(value)
        if not value then
          return true
        end
        return vim.fn.isdirectory(vim.fn.expand(value)) == 1, ("'%s' is not a directory"):format(value)
      end,
      "sessions directory",
    },
    max_projects = {
      user_config.max_projects,
      function(value)
        if not value then
          return true
        end
        return value > 1, "must be greater than 1"
      end,
      "maximum projects on screen",
    },
    max_todos_per_project = {
      user_config.max_todos_per_project,
      function(value)
        if not value then
          return true
        end
        return value >= 0, "must be greater than or equal to 0"
      end,
      "maximum todos per project on screen",
    },
    notes_project_header = { user_config.notes_project_header, "string" },
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
