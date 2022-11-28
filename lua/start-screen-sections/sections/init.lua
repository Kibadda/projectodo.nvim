local config = require "start-screen-sections.config"
local sessions = require "start-screen-sections.sessions"
local treesitter = require "start-screen-sections.treesitter"
local utils = require "start-screen-sections.utils"

local M = {}

local function build_section(data)
  local plugin = utils.get_section_module()

  local lines = {}
  local indices = {}

  if data.command then
    table.insert(lines, data.command)
    table.insert(indices, 0)
  end

  if type(data.sessions) ~= "table" then
    data.sessions = { data.sessions }
  end

  for _, session_name in ipairs(data.sessions) do
    if sessions.session_files[session_name] then
      table.insert(
        lines,
        plugin.to_line {
          text = session_name,
          action = ("source %s"):format(sessions.session_files[session_name].path),
        }
      )
      table.insert(indices, data.index)
      data.index = data.index + 1
      sessions.session_files[session_name].used = true
    end
  end

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
  local plugin = utils.get_section_module()

  return build_section {
    name = config.get_main_section().name,
    command = plugin.to_line {
      text = "Create New Project",
      action = ("e %s/%s.%s"):format(config.get_notes(), config.get_notes_main_file(), config.get_notes_extension()),
    },
    sessions = config.get_main_section().sessions,
    todo_file = config.get_notes_main_file(),
    index = 1,
  }
end

local function current_projects()
  local projects = treesitter.get_projects(config.get_notes_main_file())

  local sections = {}

  local index = (#config.get_main_section().sessions + 1) * 10
  for _, project in ipairs(projects) do
    table.insert(
      sections,
      build_section {
        name = project.name,
        sessions = project.file_name,
        todo_file = project.file_name,
        index = index,
      }
    )
    index = index + 10
  end

  return sections
end

local function remaining_sessions()
  local session_names = {}

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
  local sections = {}

  table.insert(sections, general())

  for _, project in ipairs(current_projects()) do
    table.insert(sections, project)
  end

  table.insert(sections, remaining_sessions())

  return sections
end

return M
