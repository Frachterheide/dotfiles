--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
-- Set fat cursor
vim.o.guicursor = ""
-- Set highlight on search
vim.o.showmode = false
vim.o.hlsearch = false
vim.o.incsearch = true
-- Make line numbers default
vim.wo.number = true
-- Make line numbers relative
vim.wo.relativenumber = true
-- Set tab width
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.o.wrap = false
vim.o.swapfile = false
vim.o.backup = false
-- Enable mouse mode
vim.o.mouse = 'a'
-- Sync clipboard
vim.o.clipboard = 'unnamedplus'
-- Enable break indent
vim.o.breakindent = true
-- Save undo history
vim.o.undofile = true
-- case-sensitive if \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true
-- Keep signcolumn on by default
vim.o.scrolloff = 8
vim.wo.signcolumn = 'yes'
-- Decrease update time
vim.o.updatetime = 250
vim.o.timeoutlen = 300
-- better completion
vim.o.completeopt = 'menuone,noselect'
-- column boundary
vim.o.colorcolumn = '80'
-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true
