local M = {}

local Item = require "projectodo.classes.item"
local config = require "projectodo.config"

function M.get_data(issues, ignore_labels)
  local labels = {}
  for _, issue in ipairs(issues) do
    for _, label in ipairs(issue.labels) do
      if not vim.tbl_contains(ignore_labels, label) and config.options.sources.git.filter(issue) then
        labels[label] = labels[label] or {}
        table.insert(labels[label], Item:create(issue.title))
      end
    end
  end
  return labels
end

return M
