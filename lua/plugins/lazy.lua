local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({

    -- Mason (installs language servers)
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup()
        end,
    },

    -- Mason <-> LSP bridge
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = { "williamboman/mason.nvim" },
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "lua_ls",
                    "ts_ls",
                    "html",
                    "jsonls",
                    "eslint",
                    "tailwindcss",
                },
                automatic_installation = true,
            })
        end,
    },

    -- LSP config (Neovim 0.11+ safe)
    {
        "neovim/nvim-lspconfig",
        config = function()
            -- Lua
            vim.lsp.config("lua_ls", {
                settings = {
                    Lua = {
                        diagnostics = { globals = { "vim" } },
                    },
                },
            })

            -- JS / TS
            vim.lsp.config("ts_ls", {})

            -- HTML
            vim.lsp.config("html", {})

            -- Enable servers
            vim.lsp.enable({
                "lua_ls",
                "ts_ls",
                "html",
                "eslint",
                "jsonls",
                "tailwindcss",
            })
        end,
    },

    -- FZF Lua
    {
        "ibhagwan/fzf-lua",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            local fzf = require("fzf-lua")
            vim.keymap.set("n", "<leader>pf", fzf.files, { noremap = true, silent = true })
            vim.keymap.set("n", "<leader>ps", fzf.live_grep, { noremap = true, silent = true })
            fzf.setup({
                winopts = { height = 0.6, width = 0.8, row = 0.3, col = 0.1, border = "rounded" },
                fzf_opts = {
                    ['--color'] = 'bg+:#93a1a1,fg+:#ffffff,hl:#cb4b16,hl+:#cb4b16'
                },
            })
        end,
    },

    -- UndoTree
    {
        "mbbill/undotree",
        config = function()
            vim.keymap.set("n", "<leader>u", ":UndotreeToggle<CR>", { noremap = true, silent = true })
        end,
    },

    -- Git signs
    {
        "lewis6991/gitsigns.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("gitsigns").setup({
                signs = {
                    add          = { text = '+' },
                    change       = { text = '~' },
                    delete       = { text = '_' },
                    topdelete    = { text = '‾' },
                    changedelete = { text = '~' },
                },
            })
            vim.keymap.set("n", "<leader>gs", ":Gitsigns toggle_current_line_blame<CR>", { noremap = true, silent = true })
        end,
    },

    -- Harpoon
    {
        "ThePrimeagen/harpoon",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            local mark = require("harpoon.mark")
            local ui = require("harpoon.ui")
            vim.keymap.set("n", "<leader>a", mark.add_file, { noremap = true, silent = true })
            vim.keymap.set("n", "<leader>h", ui.toggle_quick_menu, { noremap = true, silent = true })
        end,
    },

    -- Autocomplete
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-nvim-lsp",
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
            "rafamadriz/friendly-snippets",
        },
        config = function()
            local cmp = require("cmp")
            local luasnip = require("luasnip")

            require("luasnip.loaders.from_vscode").lazy_load() 

            cmp.setup({
                snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
                mapping = cmp.mapping.preset.insert({
                    ["<C-n>"] = cmp.mapping.select_next_item(),
                    ["<C-p>"] = cmp.mapping.select_prev_item(),
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<C-y>"] = cmp.mapping.confirm({ select = true }),
                }),
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                    { name = "buffer" },
                    { name = "path" },
                }),
            })
        end,
    },

    -- Solarized light
    {
        "maxmx03/solarized.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            vim.o.termguicolors = true
            vim.o.background = "light"
            vim.cmd.colorscheme("solarized")

            -- Darker Visual Mode Highlight
            vim.api.nvim_set_hl(0, 'Visual', { bg = '#d6d1c0', fg = 'NONE' })

            -- We define 'YankColor' here. This ONLY exists when this theme is loaded.
            vim.api.nvim_set_hl(0, 'YankColor', { bg = '#93a1a1', fg = '#fdf6e3' })

            -- Highlight matching brackets
            vim.api.nvim_set_hl(0, 'MatchParen', { bg = '#d6d1c0', fg = '#073642', bold = true })
        end,
    },

    -- Treesitter
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",  -- safer, works cross-platform
        config = function()
            local status_ok, tsconfigs = pcall(require, "nvim-treesitter.configs")
            if not status_ok then return end

            tsconfigs.setup({
                ensure_installed = { "lua", "javascript", "typescript", "html", "css", "json", "tsx" },
                highlight = { enable = true },
                indent = { enable = true },
                incremental_selection = { enable = true },
                playground = { enable = true },
                auto_install = true,
            })
        end,
    },

    -- Surround (ysiw, cs, ds)
    {
        "kylechui/nvim-surround",
        version = "*", -- use latest stable
        event = "VeryLazy",
        config = function()
            require("nvim-surround").setup({})
        end,
    },

    -- Find next and prevous (cinb, canb, cilb, calb)
    {
        "wellle/targets.vim",
    }

})

