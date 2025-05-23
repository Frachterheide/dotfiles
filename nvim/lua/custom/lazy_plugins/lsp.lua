return {
    'mason-org/mason.nvim',
    dependencies = {
        -- Automatically install LSPs to stdpath for neovim
        'mason-org/mason-lspconfig.nvim',
        'neovim/nvim-lspconfig',
        -- completion
        'hrsh7th/cmp-nvim-lsp',
        -- notifications & LSP nrogress messages
        { 'j-hui/fidget.nvim', opts = { notification = { window = { winblend = 0, }, }, }, }, -- opts = {} instead of require(x).setup({})
        -- automatic lua-language-server config
        'folke/lazydev.nvim',
    },
    config = function()
        require('mason').setup()
        vim.api.nvim_create_autocmd("LspAttach", {
            desc = "Set LSP keymaps",
            callback = function(event)
                require('custom.config.lsp_keymaps').base_mapping(event.buf)
            end
        })

        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

        vim.lsp.config('clangd', {
            -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
            capabilities = capabilities
        })

        vim.lsp.config('lua_ls', {
            -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
            capabilities = capabilities,
            settings = {
                Lua = {
                    workspace = { checkThirdParty = false },
                    telemetry = { enable = false },
                },
            }
        })

        require('mason-lspconfig').setup({
            ensure_installed = {
                "clangd",
                "lua_ls",
                "jdtls"
            },
            automatic_enable = {
                exclude = {
                    "jdtls"
                }
            }
        })

        -- Setup signature help, docs and completion for lua vim API
        require('lazydev').setup()
    end
}
