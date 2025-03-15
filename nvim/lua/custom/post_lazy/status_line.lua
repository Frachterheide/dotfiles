function string.starts(String, Start)
    return string.sub(String, 1, string.len(Start)) == Start
end

local highlights = {
    { 'StatusLine',   { fg = '#dcd7ba', bg = '#1f1f28', blend = 80 } },
    { 'StatusLineNC', { fg = '#090618', bg = '#1f1f28' } },
    { 'Mode',         { fg = '#090618', bg = '#7e9cd8', bold = true } },
    { 'Green',        { fg = '#76946a', bg = '#1f1f28' } },
    { 'White',        { fg = '#c8c093', bg = '#1f1f28' } },
    { 'Yellow',       { fg = '#c0a36e', bg = '#1f1f28' } },
    { 'Red',          { fg = '#7c0a36', bg = '#1f1f28' } },
    { 'Git',          { fg = '#c8c093', bg = '#1f1f28' } },
    { 'LSP',          { fg = '#090618', bg = '#1f1f28' } },
    { 'FileType',     { fg = '#c8c093', bg = '#1f1f28' } },
    { 'Filename',     { fg = '#c8c093', bg = '#1f1f28' } },
    { 'LineCol',      { fg = '#090618', bg = '#7e9cd8', blend = 80, bold = true } },
}

for _, highlight in ipairs(highlights) do
    vim.api.nvim_set_hl(0, highlight[1], highlight[2])
end

local M = {}

M.modes = setmetatable({
    ['n'] = { 'NORMAL', 'N' },
    ['no'] = { 'N-PENDING', 'N-P' },
    ['v'] = { 'VISUAL', 'V' },
    ['V'] = { 'V-LINE', 'V-L' },
    [''] = { 'V-BLOCK', 'V-B' },
    ['s'] = { 'SELECT', 'S' },
    ['S'] = { 'S-LINE', 'S-L' },
    [''] = { 'S-BLOCK', 'S-B' },
    ['i'] = { 'INSERT', 'I' },
    ['ic'] = { 'INSERT', 'I' },
    ['R'] = { 'REPLACE', 'R' },
    ['Rv'] = { 'V-REPLACE', 'V-R' },
    ['c'] = { 'COMMAND', 'C' },
    ['cv'] = { 'VIM EX', 'V-E' },
    ['ce'] = { 'EX', 'E' },
    ['r'] = { 'PROMPT', 'P' },
    ['rm'] = { 'MORE PRMPT', 'M-P' },
    ['r?'] = { 'CONFIRM', 'C' },
    ['!'] = { 'SHELL', 'S' },
    ['t'] = { 'TERMINAL', 'T' },
}, {
    __index = function()
        return { 'Unknown', 'U' }
    end
})

M.truncate_width = setmetatable({
    mode = 12,
    git_status = 24,
    filename = 140,
    lsp = 24,
    line_col = 10,
}, {
    __index = function()
        return 80
    end
})

M.is_truncated = function(_, width)
    local current_width = vim.api.nvim_win_get_width(0)
    return current_width < width
end

M.colors = {
    active = '%#StatusLine#',
    inactive = '%#StatusLineNC#',
    mode = '%#Mode#',
    git = '%#Git#',
    green = '%#Green#',
    white = '%#White#',
    yellow = '%#Yellow#',
    red = '%#Red#',
    lsp = '%#LSP#',
    file_type = '%#FileType#',
    filename = '%#Filename#',
    line_col = '%#LineCol#',
}


M.mode = function(self)
    local current_mode = vim.api.nvim_get_mode().mode
    if self:is_truncated(self.truncate_width.mode) then
        return string.format(' %s ', self.modes[current_mode][2]):upper()
    end
    return string.format(' %s ', self.modes[current_mode][1]):upper()
end

M.vcs = function(self)
    local eval_git = function(element, prefix)
        if element and element ~= 0 then
            return prefix .. element
        else
            return ''
        end
    end

    local git_info = vim.b.gitsigns_status_dict
    if not git_info or git_info.head == '' then
        return ''
    end

    if self:is_truncated(self.truncate_width.git_status) then
        return table.concat({
            M.colors.git .. '  ',
            M.colors.git .. git_info.head,
        })
    else
        return table.concat({
            eval_git(git_info.added, ' +'),
            eval_git(git_info.changed, ' ~'),
            eval_git(git_info.removed, ' -'),
            M.colors.git .. '  ',
            M.colors.git .. git_info.head,
        })
    end
end

M.filename = function(self)
    if self:is_truncated(self.truncate_width.filename) then
        return ' %<%f '
    end
    return ' %<%F '
end

M.get_lsp_indicators = function(self)
    if self:is_truncated(self.truncate_width.lsp) then return '' end
    local count = {}
    local levels = {
        errors = vim.diagnostic.severity.ERROR,
        warnings = vim.diagnostic.severity.WARN,
        info = vim.diagnostic.severity.INFO,
        hints = vim.diagnostic.severity.HINT,
    }

    for k, level in pairs(levels) do
        count[k] = vim.tbl_count(vim.diagnostic.get(0, { severity = level }))
    end

    local errors = ''
    local warnings = ''
    local hints = ''
    local info = ''

    if count['errors'] ~= 0 then
        errors = M.colors.red .. '  ' .. count['errors']
    end
    if count['warnings'] ~= 0 then
        warnings = M.colors.yellow .. '  ' .. count['warnings']
    end
    if count['info'] ~= 0 then
        info = M.colors.green .. '  ' .. count['info']
    end
    if count['hints'] ~= 0 then
        hints = M.colors.white .. '  ' .. count['hints']
    end

    return errors .. warnings .. info .. hints
end

M.filetype = function()
    local file_name, file_ext = vim.fn.expand('%:t'), vim.fn.expand('%:e')
    local icon = require('nvim-web-devicons').get_icon(file_name, file_ext, { default = true })
    local filetype = vim.bo.filetype

    if filetype == '' then return '' end
    return string.format(' %s %s ', icon, filetype):lower()
end

M.line_info = function()
    if vim.bo.filetype == 'alpha' then
        return ''
    end
    return ' %l:%c '
end

StatusLine = {}

StatusLine.active = function()
    return table.concat({
        M.colors.active,
        M.colors.mode .. M:mode(),
        M.colors.git .. M:vcs(),
        '%=' .. M.colors.filename .. M:filename() .. '%=',
        M.colors.lsp .. M:get_lsp_indicators(),
        M.colors.file_type .. M.filetype(),
        M.colors.line_col .. M:line_info(),
    })
end

StatusLine.inactive = function()
    return M.colors.inactive .. '%= %F %='
end

-- Create the StatusLine augroup
local statusline_group = vim.api.nvim_create_augroup('StatusLine', { clear = true })

-- Define the autocmds
vim.api.nvim_create_autocmd({ 'WinEnter', 'BufEnter' }, {
    group = statusline_group,
    pattern = '*',
    command = 'setlocal statusline=%!v:lua.StatusLine.active()',
})

vim.api.nvim_create_autocmd({ 'WinLeave', 'BufLeave' }, {
    group = statusline_group,
    pattern = '*',
    command = 'setlocal statusline=%!v:lua.StatusLine.inactive()',
})
