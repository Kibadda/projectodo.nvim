local config = require "start-screen-sections.config"

local M = {}

function M.get_section_module()
  local module = ("start-screen-sections.sections.%s"):format(config.get_plugin())
  return require(module)
end

function M.get_treesitter_module()
  local module = ("start-screen-sections.treesitter.%s"):format(config.get_notes_extension())
  return require(module)
end

return M
