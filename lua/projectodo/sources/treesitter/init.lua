local Source = require "projectodo.classes.source"
local Section = require "projectodo.classes.section"
local Item = require "projectodo.classes.item"

local Treesitter = Source:create "treesitter"

---@class ProjectodoTreesitterQueries
---@field sections Query
---@field items Query

---@param filetype string
---@return ProjectodoTreesitterQueries?
local function get_queries(filetype)
  if filetype == "norg" then
    return require "projectodo.sources.treesitter.norg"
  -- elseif filetype == "md" then
  --   return require "projectodo.sources.treesitter.markdown"
  else
    return nil
  end
end

function Treesitter:load()
  local queries = get_queries(self.config.filetype)

  if not queries then
    return
  end

  local dir = vim.fn.expand(self.config.dir .. "/")

  local main_as_string = table.concat(vim.fn.readfile(dir .. self.config.main .. "." .. self.config.filetype), "\n")
  local main_root = vim.treesitter.get_string_parser(main_as_string, self.config.filetype):parse()[1]:root()

  for pattern, match in queries.sections:iter_matches(main_root, "", 1, -1) do
    if pattern == 1 then
      local capture = {}

      for id, node in pairs(match) do
        local name = queries.sections.captures[id]
        if name ~= "project" then
          capture[name] = vim.treesitter.get_node_text(node, main_as_string)
        end
      end

      local section_as_string = table.concat(vim.fn.readfile(dir .. capture.file_name .. "." .. self.config.filetype))
      local section_root = vim.treesitter.get_string_parser(section_as_string, self.config.filetype):parse()[1]:root()

      local items = {}
      for _, section_match in queries.items:iter_matches(section_root, "", 1, -1) do
        for section_id, section_node in pairs(section_match) do
          local section_name = queries.items.captures[section_id]
          if section_name == "todo_text" then
            table.insert(items, Item:create(vim.treesitter.get_node_text(section_node, section_as_string)))
          end
        end
      end

      table.insert(self.data, Section:create(capture.name, items))
    end
  end
end

function Treesitter:open() end

return Treesitter
