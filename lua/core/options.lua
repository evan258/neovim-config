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
-- vim.api.nvim_create_autocmd("TextYankPost", {
--   callback = function()
--     vim.highlight.on_yank({ higroup = "IncSearch", timeout = 200 })
--   end,
-- })


vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    -- We try to use 'YankColor' first. If it doesn't exist (because you 
    -- changed themes), it will automatically fall back to 'IncSearch'.
    local hl_group = vim.fn.hlexists("YankColor") == 1 and "YankColor" or "IncSearch"
    
    vim.highlight.on_yank({ higroup = hl_group, timeout = 200 })
  end,
})
