return {
    'williamboman/mason.nvim',
    dependencies = {
        -- Automatically install LSPs to stdpath for neovim
        'williamboman/mason-lspconfig.nvim',
        'neovim/nvim-lspconfig',
        -- completion
        'hrsh7th/cmp-nvim-lsp',
        -- notifications & LSP nrogress messages
        { 'j-hui/fidget.nvim', opts = { notification = { window = { winblend = 0, }, }, }, }, -- opts = {} instead of require(x).setup({})
        -- automatic lua-language-server config
        'folke/lazydev.nvim',
    }
}
