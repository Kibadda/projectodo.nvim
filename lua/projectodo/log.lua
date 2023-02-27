local M = {}

function M.write(data)
  local config = require "projectodo.config"
  if config.options.log then
    local log_file = io.open(config.options.log, "a+")
    if log_file then
      local lines = {}
      table.insert(lines, data)
      table.insert(lines, debug.traceback())
      log_file:write(("[%s]: %s\n"):format(os.date "%Y-%m-%d %H:%M:%S", table.concat(lines, "\n")))
      log_file:close()
    end
  end
end

function M.truncate()
  local config = require "projectodo.config"
  if config.options.log then
    io.open(config.options.log, "w+"):close()
  end
end

return M
