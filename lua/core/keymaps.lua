vim.g.mapleader = " "

local keymap = vim.keymap.set

-- Basic mappings
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Open file explorer (netrw)
vim.keymap.set("n", "<leader>pv", ":Ex<CR>", { noremap = true, silent = true })

-- Move selected lines down with Shift+J
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { noremap = true, silent = true })

-- Move selected lines up with Shift+K
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { noremap = true, silent = true })

-- Diagnostics
keymap("n", "[d", vim.diagnostic.goto_prev, { noremap = true, silent = true })
keymap("n", "]d", vim.diagnostic.goto_next, { noremap = true, silent = true })
keymap("n", "<leader>e", vim.diagnostic.open_float, { noremap = true, silent = true })
keymap("n", "<leader>q", vim.diagnostic.setloclist, { noremap = true, silent = true })

-- Code Action
vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { desc = "LSP Code Actions (Quick Fix)" })
