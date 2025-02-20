return {
   {
      "folke/tokyonight.nvim",
      lazy = false,
      priority = 1000,
      enabled = false,
      config = function ()
         require("tokyonight").setup()
         vim.cmd.colorscheme "tokyonight-moon"
      end
   },

   {
      "catppuccin/nvim",
      priority = 1000,
      lazy = false,
      enabled = false,
      config = function ()
         vim.cmd.colorscheme "catppuccin-mocha"
      end,
   },

   {
      "ellisonleao/gruvbox.nvim",
      priority = 1000,
      lazy = false,
      enabled = false,
      config = function ()
         require("gruvbox").setup({ contrast = "soft" })
         vim.cmd.colorscheme "gruvbox"
      end
   },

   {
      "rebelot/kanagawa.nvim",
      priority = 1000,
      lazy = false,
      enabled = false,
      config = function ()
         local kanagawa = require("kanagawa")

         ---@diagnostic disable-next-line: missing-fields
         kanagawa.setup {
            transparent = true,
            theme = "lotus",
            commentStyle = { italic = true },
            keywordStyle = { italic = true },
         }

         kanagawa.load "lotus"

         vim.cmd "highlight! SignColumn guibg=NONE"
         vim.cmd "highlight! LineNr guibg=NONE"

         local diagnostics = { "Hint", "Info", "Warn", "Error", "Ok" }

         for _, diagnostic in ipairs(diagnostics) do
            vim.cmd("highlight! DiagnosticSign" .. diagnostic .. " guibg=NONE")
         end
      end
   },

   {
      "nvim-telescope/telescope.nvim",
      opts = {},
      dependencies = {'nvim-lua/plenary.nvim'},
      config = function ()
         local builtin = require("telescope.builtin")
         vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
         vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
         vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
         vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })
      end
   },

   {
      'nvim-treesitter/nvim-treesitter',
      config = function ()
         ---@diagnostic disable-next-line
         require('nvim-treesitter.configs').setup({
            ensure_installed = {'lua', 'vim', 'c', 'cpp', 'zig', 'nix', 'rust', 'html', 'css', 'javascript', 'typescript', 'tsx', 'bash', 'vimdoc', 'php', 'phpdoc', 'markdown', 'markdown_inline', 'query'},
            highlight = { enable = true },
            additional_vim_regex_highlighting = true,
         })
      end
   },

   {
      'stevearc/oil.nvim',
      config = function ()
         require('oil').setup()
         vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
      end
   },

   {
      'williamboman/mason.nvim',
      dependencies = {
         'williamboman/mason-lspconfig.nvim',
      },
      config = function ()
         require('mason-lspconfig').setup()
         require('mason').setup()
      end
   },

   {
      'folke/lazydev.nvim',
      ft = 'lua',
      opts = {
         library = {
            { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
         }
      }
   },

   {
      'saghen/blink.cmp',
      dependencies = {'rafamadriz/friendly-snippets'},
      version = '*',
      ---@module 'blink.cmp'
      ---@type blink.cmp.Config
      opts = {
         keymap = { preset = 'default' },

         appearance = {
            use_nvim_cmp_as_default = true,
            nerd_font_variant = 'normal',
         },

         sources = {
            default = {
               'lazydev',
               'lsp',
               'path',
               'snippets',
               'buffer'
            },

            providers = {
               lazydev = {
                  name = "LazyDev",
                  module = "lazydev.integrations.blink",
                  score_offset = 100,
               },
            },
         },
      },

      opts_extend = {'sources.default'}
   },

   {
      'neovim/nvim-lspconfig',

      dependencies = {'saghen/blink.cmp'},

      opts = {
         servers = {
            lua_ls = {},
            ols = {},
            rust_analyzer = {},
            ts_ls = {},
            zls = {},
            tailwindcss = {},
         },
      },

      config = function (_, opts)
         local lspconfig = require('lspconfig')

         for server, config in pairs(opts.servers) do
            config.capabilities = require('blink.cmp').get_lsp_capabilities(config.capabilities)
            lspconfig[server].setup(config)
         end
      end,
   },

   {
      'tpope/vim-fugitive',
      lazy = false,

      config = function ()
         vim.cmd.cabbrev 'git Git'
      end
   }
}
