local M = {}

function M.check()
  vim.health.start "projectodo report"

  -- TODO: implement health checks
  vim.health.ok "looks good"

  local Config = require "terminal.config"
  local valid = vim.tbl_keys(Config.defaults())
  for opt in pairs(Config.options) do
    if not vim.tbl_contains(valid, opt) then
      vim.health.warn("unknown option: " .. opt)
    end
  end
end

return M
