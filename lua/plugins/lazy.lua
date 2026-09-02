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
          "prismals",
        },
        automatic_installation = true,
      })
    end,
  },

  -- LSP config (Neovim 0.11+ native style)
  {
    "neovim/nvim-lspconfig",
    config = function()
      -- Lua configuration
      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            diagnostics = { globals = { "vim" } },
          },
        },
      })

      -- JS / TS configuration
      vim.lsp.config("ts_ls", {})

      -- HTML configuration
      vim.lsp.config("html", {})

      -- Prisma configuration
      vim.lsp.config("prismals", {})

      -- Activate the servers globally
      vim.lsp.enable({
        "lua_ls",
        "ts_ls",
        "html",
        "eslint",
        "jsonls",
        "tailwindcss",
        "prismals",
      })
    end,
  },

  -- FZF Lua
  {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local fzf = require("fzf-lua")

      vim.keymap.set("n", "<leader>pf", fzf.files, {
        noremap = true,
        silent = true,
      })

      vim.keymap.set("n", "<leader>ps", fzf.live_grep, {
        noremap = true,
        silent = true,
      })

      fzf.setup({
        winopts = {
          height = 0.6,
          width = 0.8,
          row = 0.3,
          col = 0.1,
          border = "rounded",
        },
        fzf_opts = {
          ["--color"] =
            "bg+:#93a1a1,fg+:#ffffff,hl:#cb4b16,hl+:#cb4b16",
        },
      })
    end,
  },

  -- UndoTree
  {
    "mbbill/undotree",
    config = function()
      vim.keymap.set("n", "<leader>u", ":UndotreeToggle<CR>", {
        noremap = true,
        silent = true,
      })
    end,
  },

  -- Git signs
  {
    "lewis6991/gitsigns.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("gitsigns").setup({
        signs = {
          add = { text = "+" },
          change = { text = "~" },
          delete = { text = "_" },
          topdelete = { text = "‾" },
          changedelete = { text = "~" },
        },
      })

      vim.keymap.set(
        "n",
        "<leader>gs",
        ":Gitsigns toggle_current_line_blame<CR>",
        { noremap = true, silent = true }
      )
    end,
  },

  -- Harpoon
  {
    "ThePrimeagen/harpoon",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local mark = require("harpoon.mark")
      local ui = require("harpoon.ui")

      vim.keymap.set("n", "<leader>a", mark.add_file, {
        noremap = true,
        silent = true,
      })

      vim.keymap.set("n", "<leader>h", ui.toggle_quick_menu, {
        noremap = true,
        silent = true,
      })
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
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },

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

  -- Kanagawa Dragon
  {
    "rebelot/kanagawa.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.o.termguicolors = true
      vim.o.background = "dark"

      require("kanagawa").setup({
        theme = "dragon",
        background = {
          dark = "dragon",
          light = "lotus",
        },
      })

      vim.cmd.colorscheme("kanagawa-dragon")
    end,
  },

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",

    config = function()
      require("nvim-treesitter").setup()

      require("nvim-treesitter").install({
        "lua",
        "javascript",
        "typescript",
        "tsx",
        "html",
        "css",
        "json",
      })

      vim.api.nvim_create_autocmd("FileType", {
        pattern = {
          "lua",
          "javascript",
          "typescript",
          "typescriptreact",
          "html",
          "css",
          "json",
        },

        callback = function()
          vim.treesitter.start()

          vim.bo.indentexpr =
            "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })
    end,
  },

  -- Auto close / rename HTML and JSX tags
  {
    "windwp/nvim-ts-autotag",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {},
  },

  -- Auto close brackets, parentheses, quotes, etc.
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/nvim-cmp",
    },
    config = function()
      local npairs = require("nvim-autopairs")

      npairs.setup({
        check_ts = true,

        ts_config = {
          lua = { "string" },
          javascript = { "template_string" },
          typescript = { "template_string" },
        },
      })

      local cmp_autopairs =
        require("nvim-autopairs.completion.cmp")

      local cmp = require("cmp")

      cmp.event:on(
        "confirm_done",
        cmp_autopairs.on_confirm_done()
      )
    end,
  },

  -- Surround (ysiw, cs, ds)
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({})
    end,
  },

  -- Find next and previous (cinb, canb, cilb, calb)
  {
    "wellle/targets.vim",
  },

})
