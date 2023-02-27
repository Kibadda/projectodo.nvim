---@class ProjectodoSession
---@field path string
---@field used boolean

local M = {
  ---@type ProjectodoSession[]
  session_files = {},
}

function M.load_session_files()
  local config = require "projectodo.config"
  if vim.fn.isdirectory(vim.fn.expand(config.options.sessions)) == 0 then
    return
  end

  local files = vim.fs.find(function(file)
    return file:match "^__" == nil
  end, {
    path = config.options.sessions,
    type = "file",
    limit = math.huge,
  })

  for _, session_file in ipairs(files) do
    local split = vim.split(session_file, "/")
    local file_name = split[#split]
    M.session_files[file_name] = {
      path = session_file,
      used = false,
    }
  end
end

return M
