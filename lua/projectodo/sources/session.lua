local Source = require "projectodo.classes.source"
local Section = require "projectodo.classes.section"
local Item = require "projectodo.classes.item"

local Session = Source:create "session"

function Session:load()
  if vim.fn.isdirectory(vim.fn.expand(self.config.dir)) == 1 then
    local items = {}
    for name, type in vim.fs.dir(self.config.dir) do
      if type == "file" then
        local load_action = self.config.load_action and self.config.load_action(name)
          or function()
            vim.cmd.source(("%s/%s"):format(self.config.dir, name))
          end
        table.insert(items, Item:create(name, load_action))
      end
    end
    self.data = { Section:create("Sessions", items) }
  end
end

return Session
