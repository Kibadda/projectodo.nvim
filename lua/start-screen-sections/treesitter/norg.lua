local M = {}

function M.get_undone_todos_query()
  return [[
    (todo_item1
      state: (todo_item_undone)
      content: (paragraph (paragraph_segment) @todo)
    )
  ]]
end

function M.get_projects_query()
  return [[
    (heading2
      title: (paragraph_segment) @project
      content: (generic_list
        (unordered_list1
          content: (paragraph
            (paragraph_segment
              (link
                (link_location
                  file: (link_file_text) @file_name)
                (link_description
                  text: (paragraph_segment) @name)))))))
    (#match? @project "%s")
  ]]
end

return M
