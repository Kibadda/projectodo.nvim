local M = {}

local function check_file(file_name)
  local config = require "projectodo.config"

  local file_path =
    vim.fn.expand(("%s/%s.%s"):format(config.options.notes.dir, file_name, config.options.notes.extension))

  return vim.fn.filereadable(file_path) == 1, file_path
end

local function query_file(query_string, file_name)
  local config = require "projectodo.config"

  local file_as_string = table.concat(vim.fn.readfile(file_name), "\n")

  local root = vim.treesitter.get_string_parser(file_as_string, config.options.notes.extension, {}):parse()[1]:root()
  local query = vim.treesitter.query.parse_query(config.options.notes.extension, query_string)

  return query, root, file_as_string
end

function M.get_undone_todos(file_name)
  local ok, file_path = check_file(file_name)
  if not ok then
    return {}
  end

  local utils = require "projectodo.utils"
  local query, root, file_as_string = query_file(utils.get_treesitter_module().get_undone_todos_query(), file_path)

  local plugin = utils.get_section_module()

  local captures = {}

  for _, match in query:iter_matches(root, "", 1, -1) do
    for id, node in pairs(match) do
      local name = query.captures[id]
      if name == "todo_text" then
        table.insert(
          captures,
          plugin.to_line {
            text = vim.treesitter.query.get_node_text(node, file_as_string),
            action = "",
          }
        )
      end
    end
  end

  return vim.list_slice(captures, 1, require("projectodo.config").options.projects.todos)
end

---@class ProjectodoProject
---@field name string
---@field file_name string

---@return ProjectodoProject[]
function M.get_projects(file_name)
  local ok, file_path = check_file(file_name)

  if not ok then
    return {}
  end

  local utils = require "projectodo.utils"
  local config = require "projectodo.config"

  local query, root, file_as_string =
    query_file(utils.get_treesitter_module().get_projects_query():format(config.options.notes.header), file_path)

  local captures = {}

  for pattern, match in query:iter_matches(root, "", 1, -1) do
    if pattern == 1 then
      local capture = {}

      for id, node in pairs(match) do
        local name = query.captures[id]
        if name ~= "project" then
          capture[name] = vim.treesitter.query.get_node_text(node, file_as_string)
        end
      end

      table.insert(captures, capture)
    end
  end

  return vim.list_slice(captures, 1, config.options.projects.max)
end

return M
