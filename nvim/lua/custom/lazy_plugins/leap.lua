return {
	url = "https://codeberg.org/andyg/leap.nvim",
	dependencies = {
		'tpope/vim-repeat'
	},
	config = function()
		require('leap')
		vim.keymap.set({'n', 'x', 'o'}, 's',	'<Plug>(leap-forward)')
		vim.keymap.set({'n', 'x', 'o'}, 'S',	'<Plug>(leap-backward)')
		vim.keymap.set('n',				'gs',	'<Plug>(leap-from-window)')
	end
}
