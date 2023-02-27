local M = {}

function M.check()
  vim.health.report_start("projectodo report")

  -- TODO: implement health checks
  vim.health.report_ok("✅ looks good")
end

return M
