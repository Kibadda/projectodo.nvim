local config = require "start-screen-sections.config"
local utils = require "start-screen-sections.utils"

local M = {}

local function check_file(file_name)
  local file_path = vim.fn.expand(("%s/%s.norg"):format(config.get_notes(), file_name))

  if vim.fn.filereadable(file_path) == 0 then
    return false, ""
  end

  return true, file_path
end

local function query_file(query_string, file_name)
  local file_as_string = table.concat(vim.fn.readfile(file_name), "\n")

  local root = vim.treesitter.get_string_parser(file_as_string, "norg", {}):parse()[1]:root()
  local query = vim.treesitter.parse_query("norg", query_string)

  return query, root, file_as_string
end

function M.get_undone_todos(file_name)
  local ok, file_path = check_file(file_name)

  if not ok then
    return {}
  end

  local query, root, file_as_string = query_file(
    [[
      (todo_item1
        state: (todo_item_undone)
        content: (paragraph (paragraph_segment) @todo)
      )
    ]],
    file_path
  )

  local captures = {}

  local plugin = utils.get_section_module()

  for _, node in query:iter_captures(root) do
    table.insert(
      captures,
      plugin.to_line {
        text = vim.treesitter.get_node_text(node, file_as_string),
        action = "",
      }
    )
  end

  return vim.list_slice(captures, 1, config.get_max_todos_per_project())
end

function M.get_projects(file_name)
  local ok, file_path = check_file(file_name)

  if not ok then
    return {}
  end

  local query, root, file_as_string = query_file(
    string.format(
      [[
        (heading2
          title: (paragraph_segment) @project
          content: (generic_list
            (unordered_list1
              content: (paragraph
                (paragraph_segment
                  (link
                    (link_location
                      file: (link_file_text) @file_name)
                    (link_description
                      text: (paragraph_segment) @name)))))))
        (#match? @project "%s")
      ]],
      config.get_notes_project_header()
    ),
    file_path
  )

  local captures = {}

  for pattern, match in query:iter_matches(root) do
    if pattern == 1 then
      local capture = {}

      for id, node in pairs(match) do
        local name = query.captures[id]
        if name ~= "project" then
          capture[name] = vim.treesitter.get_node_text(node, file_as_string)
        end
      end

      table.insert(captures, capture)
    end
  end

  return vim.list_slice(captures, 1, config.get_max_projects())
end

return M
