local M = {}

function M.base_mapping(bufnr)
    local ts_builtin = require('telescope.builtin')
    local nmap = function(keys, func, desc)
        vim.keymap.set('n', keys, func, { buffer = bufnr, desc = 'LSP: ' .. desc })
    end

    nmap('gd', ts_builtin.lsp_definitions, '[G]oto [D]efinition')
    nmap('gr', ts_builtin.lsp_references, '[G]oto [R]eferences')
    nmap('gI', ts_builtin.lsp_implementations, '[G]oto [I]mplementation')
    nmap('<leader>D', ts_builtin.lsp_type_definitions, 'Type [D]efinition')
    nmap('<leader>ds', ts_builtin.lsp_document_symbols, '[D]ocument [S]ymbols')
    nmap('<leader>ws', ts_builtin.lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

    nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
    nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
    nmap('gD', vim.lsp.buf.declaration, '[G]o to [D]eclaration')
    -- See `:help K` for why this keymap
    nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
    nmap('<C-g>', vim.lsp.buf.signature_help, 'Signature Documentation')
    -- Lesser used LSP functionality
    nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
    nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
    nmap('<leader>wl', function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, '[W]orkspace [L]ist Folders')
    vim.keymap.set('v', '<leader>ca', '<ESC><CMD>lua vim.lsp.buf.range_code_action()<CR>',
        { noremap = true, silent = true, buffer = bufnr, desc = 'Code actions' })
    vim.keymap.set('n', '<leader>f', vim.lsp.buf.format,
        { noremap = true, silent = true, buffer = vim.api.nvim_get_current_buf(), desc = 'Format current buffer with LSP' })
end

return M
