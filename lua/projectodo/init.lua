local config = require "projectodo.config"
local sessions = require "projectodo.sessions"
local sections = require "projectodo.sections"

local M = {}

function M.get_sections(user_config)
  config.set(user_config)

  sessions.load_session_files()

  return sections.get_sections()
end

return M
