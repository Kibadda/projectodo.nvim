local M = {}

function M.to_line(data)
  return {
    line = data.text,
    cmd = data.action,
  }
end

function M.to_section(data)
  return {
    header = vim.fn["startify#pad"] { data.title },
    type = function()
      return data.lines
    end,
    indices = data.indices,
  }
end

return M
