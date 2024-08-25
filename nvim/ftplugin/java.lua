-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

local config = require('custom.lsp_config.nvim_jdtls').jdtls_config(capabilities)
require('jdtls').start_or_attach(config)
