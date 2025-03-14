require('mason').setup()
local mason_lspconfig = require('mason-lspconfig')
mason_lspconfig.setup()

local servers = {
  clangd = {},
  -- gopls = {},
  -- rust_analyzer = {},
  -- html = { filetypes = { 'html', 'twig', 'hbs'} },
  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
}

-- Setup signature help, docs and completion for lua vim API
require('lazydev').setup()

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- ensure above servers are installed
mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers),
}

-- [[ Configure LSP ]]
local on_attach = function(_, bufnr)
  require('custom.lsp_config.lsp_keymaps').base_mapping(bufnr)
end

mason_lspconfig.setup_handlers {
  function(server_name)
    require('lspconfig')[server_name].setup {
      capabilities = capabilities,
      on_attach = on_attach,
      settings = servers[server_name],
      filetypes = (servers[server_name] or {}).filetypes,
    }
  end,
  ['jdtls'] = function() end,
}
