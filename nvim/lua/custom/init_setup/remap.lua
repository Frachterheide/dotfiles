-- [[ Basic Keymaps ]]

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
vim.keymap.set('n', '<leader>pv', vim.cmd.Ex)

-- Remap for dealing with word wrap
--vim.keymap.set('n', 'k', 'v:count == 0 ? "gk" : "kd"', { expr = true, silent = true })
--vim.keymap.set('n', 'j', 'v:count == 0 ? "gj" : "kj"', { expr = true, silent = true })

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.get_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.get_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv", { desc = 'Move selection down (with indentation)' })
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv", { desc = 'Move selection up (with indentation)' })

vim.keymap.set('n', 'J', 'mzJ`z', { desc = 'Cursor in place while appending next line to current with space' })
vim.keymap.set('n', '<C-d>', '<C-d>zz', { desc = 'Center cursor while jumping down' })
vim.keymap.set('n', '<C-u>', '<C-u>zz', { desc = 'Center cursor while jumping up' })
vim.keymap.set('n', 'n', 'nzzzv', { desc = 'Center cursor while jumping through search results' })
vim.keymap.set('n', 'N', 'Nzzzv', { desc = 'Center cursor while backward jumping through search results' })

-- greatest remap ever
vim.keymap.set('x', '<leader>p', [["_dP]], { desc = 'Paste over without losing pasted value' })

-- next greatest remap ever : asbjornHaland
vim.keymap.set({ 'n', 'v' }, '<leader>y', [["+y]], { desc = 'Yank to system clipboard' })
vim.keymap.set('n', '<leader>Y', [["+Y]], { desc = 'Yank line to system clipboard' })

vim.keymap.set({ 'n', 'v' }, '<leader>dv', [["_d]], { desc = '[D]elete to [v]oid register' })

vim.keymap.set('n', 'Q', '<nop>')
--vim.keymap.set('n', "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")

vim.keymap.set('n', '<C-n>', '<cmd>cnext<CR>zz')
vim.keymap.set('n', '<C-p>', '<cmd>cprev<CR>zz')
vim.keymap.set('n', '<leader>k', '<cmd>lnext<CR>zz', { desc = 'Jump to next quickfix' })
vim.keymap.set('n', '<leader>j', '<cmd>lprev<CR>zz', { desc = 'Jump to previous quickfix' })

vim.keymap.set('n', '<leader>rw', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
  { desc = 'Replace current word' })
vim.keymap.set('n', '<leader>x', '<cmd>!chmod +x %<CR>', { silent = true, desc = 'Make current file executable' })
