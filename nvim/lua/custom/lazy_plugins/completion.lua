return {
  'hrsh7th/nvim-cmp',
  event = 'InsertEnter',
  priority = 100,
  dependencies = {
    -- Adds a number of user-friendly snippets
    'rafamadriz/friendly-snippets',
    'onsails/lspkind.nvim',
    'hrsh7th/cmp-cmdline',
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-nvim-lsp-document-symbol',
    'hrsh7th/cmp-nvim-lsp-signature-help',
    'ray-x/cmp-sql',
    'rcarriga/cmp-dap',
    'jc-doyle/cmp-pandoc-references',
    'tamago324/cmp-zsh',
    -- lua snippets and auto expansion with nvim-cmp
    { 'L3MON4D3/LuaSnip', build = 'make install_jsregexp' },
    'saadparwaiz1/cmp_luasnip',
  },
  config = function()
    vim.opt.completeopt = { "menu", "menuone", "noselect" }
    vim.opt.shortmess:append "c"

    local lspkind = require("lspkind")
    lspkind.init {}

    local cmp = require("cmp")
    local ls = require("luasnip")

    cmp.setup {
      sources = {
        { name = "nvim_lsp" },
        { name = "path" },
        { name = "buffer" },
        { name = "nvim_lsp_signature_help" },
        { name = "nvim_lsp_document_symbol" },
        { name = "zsh" },
      },
      mapping = {
        ["<C-n>"] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert },
        ["<C-p>"] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert },
        ["<C-y>"] = cmp.mapping(
          cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Insert,
            select = true,
          },
          { "i", "c" }
        ),
      },
      enabled = function()
        return vim.api.nvim_get_option_value("buftype", {}) ~= "prompt"
            or require("cmp_dap").is_dap_buffer()
      end,
      snippet = {
        expand = function(args)
          ls.lsp_expand(args.body)
        end,
      }
    }

    cmp.setup.filetype({ "dap-repl", "dapui_watches", "dapui_hover" }, {
      sources = {
        { name = "dap" },
      },
    })

    cmp.setup.filetype({ "sql" }, {
      sources = {
        { name = "sql" },
      }
    })

    cmp.setup.filetype({ "md" }, {
      sources = {
        { name = "pandoc_references" },
      }
    })
    --move to after lua.lua
    vim.keymap.set({ "i", "s" }, "<C-n>", function()
      if ls.expand_or_jumpable() then
        ls.expand_or_jump()
      end
    end, { silent = true })

    vim.keymap.set({ "i", "s" }, "<C-p>", function()
      if ls.jumpable(-1) then
        ls.jump(-1)
      end
    end, { silent = true })
  end
}
