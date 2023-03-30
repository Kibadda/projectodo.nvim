local Source = require "projectodo.classes.source"
local Section = require "projectodo.classes.section"
local Item = require "projectodo.classes.item"

local Session = Source:create "session"

function Session:load()
  vim.print "called"
  if vim.fn.isdirectory(vim.fn.expand(self.config.dir)) == 1 then
    local items = {}
    for name, type in vim.fs.dir(self.config.dir) do
      if type == "file" then
        table.insert(
          items,
          Item:create(name, function()
            vim.cmd.source(("%s/%s"):format(self.config.dir, name))
          end)
        )
      end
    end
    self.data = { Section:create("Sessions", items) }
  end
end

return Session
