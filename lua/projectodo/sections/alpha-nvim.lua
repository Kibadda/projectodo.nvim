local M = {}

function M.to_line(data)
  if data.action ~= "" then
    return {
      type = "button",
      val = data.text,
      on_press = function()
        local key = vim.api.nvim_replace_termcodes(":" .. data.action .. "<CR><Ignore>", true, false, true)
        vim.api.nvim_feedkeys(key, "t", false)
      end,
    }
  else
    return {
      type = "text",
      val = data.text,
    }
  end
end

function M.to_section(data)
  return {
    type = "group",
    val = {
      { type = "padding", val = 1 },
      { type = "text", val = data.title },
      { type = "padding", val = 1 },
      { type = "group", val = data.lines },
    },
  }
end

return M
