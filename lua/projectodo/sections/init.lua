local M = {}

---@class SectionData
---@field command table
---@field name string
---@field sessions table
---@field todo_file string
---@field index integer

---@param data SectionData
local function build_section(data)
  local utils = require "projectodo.utils"
  local plugin = utils.get_section_module()

  local lines = {}
  local indices = {}

  if data.command then
    table.insert(lines, data.command)
    table.insert(indices, 0)
  end

  local sessions = require "projectodo.sessions"
  for _, session_name in ipairs(data.sessions) do
    if sessions.session_files[session_name] then
      table.insert(
        lines,
        plugin.to_line { text = session_name, action = ("source %s"):format(sessions.session_files[session_name].path) }
      )
      table.insert(indices, data.index)
      data.index = data.index + 1
      sessions.session_files[session_name].used = true
    end
  end

  local treesitter = require "projectodo.treesitter"
  local todos = treesitter.get_undone_todos(data.todo_file)
  for _, todo in ipairs(todos) do
    table.insert(lines, todo)
    table.insert(indices, "")
  end

  return plugin.to_section {
    title = data.name,
    lines = lines,
    indices = indices,
  }
end

local function general()
  local plugin = require("projectodo.utils").get_section_module()
  local config = require "projectodo.config"

  local data = {
    name = config.options.main_section.name,
    sessions = config.options.main_section.sessions,
    todo_file = config.options.notes.main,
    index = 1,
  }

  if config.options.main_section.has_create_command then
    data.command = plugin.to_line {
      text = "Create New Project",
      action = ("e %s/%s.%s"):format(
        config.options.notes.dir,
        config.options.notes.main,
        config.options.notes.extension
      ),
    }
  end

  return build_section(data)
end

local function current_projects()
  local treesitter = require "projectodo.treesitter"
  local config = require "projectodo.config"
  local projects = treesitter.get_projects(config.options.notes.main)

  local sections = {}

  local index = (#config.options.main_section.sessions + 1) * 10
  for _, project in ipairs(projects) do
    table.insert(
      sections,
      build_section {
        name = project.name,
        sessions = { project.file_name },
        todo_file = project.file_name,
        index = index,
      }
    )
    index = index + 10
  end

  return sections
end

local function remaining_sections()
  local session_names = {}

  local sessions = require "projectodo.sessions"
  for name, session in pairs(sessions.session_files) do
    if not session.used then
      table.insert(session_names, name)
    end
  end

  table.sort(session_names)

  return build_section {
    name = "Sessions",
    sessions = session_names,
    todo_file = "",
    index = 90,
  }
end

function M.get_sections()
  require("projectodo.sessions").load_session_files()

  local sections = {}

  table.insert(sections, general())

  for _, project in ipairs(current_projects()) do
    table.insert(sections, project)
  end

  table.insert(sections, remaining_sections())

  return sections
end

return M
