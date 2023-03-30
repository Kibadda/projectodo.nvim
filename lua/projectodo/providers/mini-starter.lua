local Provider = require "projectodo.classes.provider"

local MiniStarter = Provider:create()

---@param source ProjectodoSource
---@param session ?ProjectodoSource
local function build_source(source, session)
  local sections = {}

  for _, section in ipairs(source:get()) do
    local lines = {}

    if source.config.uses_session and session then
      local index
      for i, item in ipairs(session:get()[1].items) do
        if item.title == section.title:lower() then
          index = i
          break
        end
      end

      if index then
        ---@type ProjectodoItem
        local s = table.remove(session:get()[1].items, index)
        table.insert(lines, {
          name = s.title,
          action = s.action,
          section = section.title,
        })
      end
    end

    for _, item in ipairs(section.items) do
      table.insert(lines, {
        name = item.title,
        action = item.action,
        section = section.title,
      })
    end

    table.insert(sections, function()
      return lines
    end)
  end

  return sections
end

function MiniStarter:build()
  local sources = require("projectodo.utils").get_sources()

  local gitlab = sources.gitlab
  local treesitter = sources.treesitter
  local session = sources.session

  if session then
    session:load()
  end

  local sections = {}
  if gitlab then
    gitlab:load()
    table.insert(sections, build_source(gitlab, session))
  end
  if treesitter then
    treesitter:load()
    table.insert(sections, build_source(treesitter, session))
  end
  if session then
    table.insert(sections, build_source(session))
  end

  return vim.tbl_flatten(sections)
end

return MiniStarter
