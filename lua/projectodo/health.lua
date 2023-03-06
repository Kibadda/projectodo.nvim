local M = {}

function M.check()
  vim.health.report_start "projectodo report"

  -- TODO: implement health checks
  vim.health.report_ok "looks good"

  local Config = require "terminal.config"
  local valid = vim.tbl_keys(Config.defaults())
  for opt in pairs(Config.options) do
    if not vim.tbl_contains(valid, opt) then
      vim.health.report_warn("unknown option: " .. opt)
    end
  end
end

return M
