-- Persistent undo
local undo_dir = vim.fn.stdpath("data") .. "/undo"
if vim.fn.isdirectory(undo_dir) == 0 then
    vim.fn.mkdir(undo_dir, "p")
end
vim.o.undofile = true
vim.o.undodir = undo_dir

require("core.options")
require("core.keymaps")
require("plugins.lazy")

