local M = {}

function M.to_line(data)
  return {
    name = data.text,
    action = data.action,
  }
end

function M.to_section(data)
  for _, line in ipairs(data.lines) do
    line.section = data.title
  end

  return function()
    return data.lines
  end
end

return M
