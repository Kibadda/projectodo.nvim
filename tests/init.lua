local cwd = ("%s/"):format(vim.loop.cwd())

vim.cmd [[set runtimepath=$VIMRUNTIME]]
vim.opt.runtimepath:append(cwd)
vim.opt.packpath = { ("%s.tests/site"):format(cwd) }

for _, plugin in ipairs {
  "nvim-lua/plenary.nvim",
} do
  local name = plugin:match ".*/(.*)"
  local package = ("%s.tests/site/pack/deps/start/"):format(cwd)
  if not vim.loop.fs_stat(package .. name) then
    vim.fn.mkdir(package, "p")
    vim.fn.system {
      "git",
      "clone",
      "--depth=1",
      ("https://github.com/%s.git"):format(plugin),
      ("%s/%s"):format(package, name),
    }
  end
end
