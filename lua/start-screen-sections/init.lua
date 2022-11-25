local config = require "start-screen-sections.config"
local sessions = require "start-screen-sections.sessions"
local sections = require "start-screen-sections.sections"

local M = {}

function M.get_sections(user_config)
  config.set(user_config)

  sessions.load_session_files()

  return sections.get_sections()
end

return M
