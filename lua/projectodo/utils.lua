local M = {}

---@class ProjectodoSection
---@field to_line (fun(data: table): table)
---@field to_section (fun(data: table): table|function)

---@return ProjectodoSection
function M.get_section_module()
  local config = require "projectodo.config"
  return require(("projectodo.sections.%s"):format(config.options.plugin))
end

---@class ProjectodoTreesitter
---@field get_undone_todos_query (fun(): string)
---@field get_projects_query (fun(): string)

---@return ProjectodoTreesitter
function M.get_treesitter_module()
  local config = require "projectodo.config"
  return require(("projectodo.treesitter.%s"):format(config.options.notes.extension))
end

return M
