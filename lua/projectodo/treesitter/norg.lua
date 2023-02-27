---@type ProjectodoTreesitter
local M = {}

function M.get_undone_todos_query()
  return [[
    (_
      state: (detached_modifier_extension (todo_item_undone))
      content: (paragraph (paragraph_segment) @todo_text)
    ) @todo
  ]]
end

function M.get_projects_query()
  return [[
    (_
      title: (paragraph_segment) @project
      content: (generic_list
        (unordered_list1
          content: (paragraph
            (paragraph_segment
              (link
                (link_location
                  file: (link_file_text) @file_name)
                (link_description
                  text: (paragraph) @name))))))
    ) @heading
    (#any-of? @heading "heading1" "heading2" "heading3" "heading4" "heading5" "heading6")
    (#match? @project "%s")
  ]]
end

return M
