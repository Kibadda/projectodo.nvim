local config = require "start-screen-sections.config"

local M = {
  session_files = {},
}

function M.load_session_files()
  if vim.fn.isdirectory(vim.fn.expand(config.get_sessions())) == 0 then
    return
  end

  local files = vim.fs.find(function(file)
    return string.match(file, "^__") == nil
  end, {
    path = config.get_sessions(),
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
