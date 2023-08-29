local M = {}

M.sections = vim.treesitter.query.parse(
  "norg",
  [[
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
)

M.items = vim.treesitter.query.parse(
  "norg",
  [[
    (_
      state: (detached_modifier_extension (todo_item_undone))
      content: (paragraph (paragraph_segment) @todo_text)
    ) @todo
  ]]
)

return M
