local config = require "start-screen-sections.config"

local M = {}

function M.get_section_module()
  local module = ("start-screen-sections.sections.%s"):format(config.get_plugin())
  return require(module)
end

return M
