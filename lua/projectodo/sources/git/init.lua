local Source = require "projectodo.classes.source"
local curl = require "plenary.curl"
local Section = require "projectodo.classes.section"

local Git = Source:create "git"

---@class ProjectodoGitAdapter
---@field get_data function

---@param adapter string
---@return ProjectodoGitAdapter
local function get_adapter(adapter)
  if adapter == "gitlab" then
    return require "projectodo.sources.git.gitlab"
  elseif adapter == "github" then
    return require "projectodo.sources.git.github"
  else
    return {
      get_data = function()
        return {}
      end,
    }
  end
end

function Git:load()
  if self.config.force or vim.fn.filereadable(self.config.cache) == 0 then
    local response = curl.get(self.config.url, {
      headers = {
        ["PRIVATE-TOKEN"] = vim.env[self.config.access_token],
      },
    })

    if response and response.status == 200 then
      local issues = vim.fn.json_decode(response.body)

      if issues then
        local data = get_adapter(self.config.adapter).get_data(issues, self.config.ignore_labels)

        ---@type ProjectodoSection[]
        local sections = {}
        for title, items in pairs(data) do
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

function Git:open()
  vim.fn.system(("xdg-open https://%s/projects/%d"):format(self.config.url, self.config.project_id))
end

return Git
