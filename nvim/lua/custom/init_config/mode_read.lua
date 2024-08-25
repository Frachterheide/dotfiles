vim.api.nvim_create_autocmd('ModeChanged', {
  pattern = '*',
  command = ":lua io.output(io.open('test.log', 'a')) io.write(vim.api.nvim_get_mode().mode .. ' ')"
})
