return {
  'folke/which-key.nvim',
  opts = {
    spec = {
      {
        -- document existing key chains
        { '<leader>c', desc = '[C]ode' },
        { '<leader>d', desc = '[D]ocument' },
        { '<leader>g', desc = '[G]it' },
        { '<leader>h', desc = 'Git [H]unk' },
        { '<leader>r', desc = '[R]ename' },
        { '<leader>s', desc = '[S]earch' },
        -- { '<leader>t', desc = '[T]oggle' },
        { '<leader>w', desc = '[W]orkspace' },
      },
      -- register which-key VISUAL mode
      -- required for visual <leader>hs (hunk stage) to work
      {
        mode = { "v" },
       { '<leader>',  desc = 'VISUAL <leader>' },
        { '<leader>h', desc = 'Git [H]unk' },
      }
    }
  },

  dependencies = {
    'echasnovski/mini.icons',
    'nvim-tree/nvim-web-devicons',
  },
}
