local Source = require "projectodo.classes.source"
local curl = require "plenary.curl"
local Section = require "projectodo.classes.section"
local Item = require "projectodo.classes.item"

local Gitlab = Source:create "gitlab"

function Gitlab:load()
  if self.config.force or vim.fn.filereadable(self.config.cache) == 0 then
    local response =
      curl.get(("https://%s/api/v4/projects/%d/issues?state=opened"):format(self.config.url, self.config.project_id), {
        headers = {
          ["PRIVATE-TOKEN"] = vim.env[self.config.access_token],
        },
      })

    if response and response.status == 200 then
      local issues = vim.fn.json_decode(response.body)

      if issues then
        local labels = {}
        for _, issue in ipairs(issues) do
          for _, label in ipairs(issue.labels) do
            if vim.tbl_contains(self.config.labels, label) then
              labels[label] = labels[label] or {}
              table.insert(labels[label], Item:create(issue.title))
            end
          end
        end

        ---@type ProjectodoSection[]
        local sections = {}
        for title, items in pairs(labels) do
          table.insert(sections, Section:create(title, items))
        end

        table.sort(sections, function(a, b)
          return a.title < b.title
        end)

        local write = io.open(self.config.cache, "w+")
        if write then
          write:write(vim.fn.json_encode(sections))
          write:close()
        end
      end
    end
  end

  local read = io.open(self.config.cache, "r")
  if read then
    local json = vim.fn.json_decode(read:read "*a")
    if json then
      self.data = json
    end
  end
end

function Gitlab:open()
  vim.fn.system(("xdg-open https://%s/projects/%d"):format(self.config.url, self.config.project_id))
end

return Gitlab
