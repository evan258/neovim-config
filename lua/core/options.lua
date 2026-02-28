vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.wrap = false
vim.opt.scrolloff = 10
vim.opt.incsearch = true
vim.opt.cursorline = true
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"

-- Use system clipboard
vim.opt.clipboard = "unnamedplus"

-- Highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 200 })
  end,
})

