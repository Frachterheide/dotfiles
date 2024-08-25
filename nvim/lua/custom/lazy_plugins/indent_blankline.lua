return {
	'lukas-reineke/indent-blankline.nvim',
	main = 'ibl',
	---@module 'ibl'
	---@type ibl.config
	opts = {},
	config = function()
		local highlight = {
			'RainbowRed',
			'RainbowYellow',
			'RainbowBlue',
			'RainbowOrange',
			'RainbowGreen',
			'RainbowViolet',
			'RainbowCyan', --teal
		}

		local hooks = require('ibl.hooks')
		hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
			vim.api.nvim_set_hl(0, 'RainbowRed', { fg = '#c4746e' })
			vim.api.nvim_set_hl(0, 'RainbowYellow', { fg = '#c4b28a' })
			vim.api.nvim_set_hl(0, 'RainbowBlue', { fg = '#658594' })
			vim.api.nvim_set_hl(0, 'RainbowOrange', { fg = '#b6927b' })
			vim.api.nvim_set_hl(0, 'RainbowGreen', { fg = '#87a987' })
			vim.api.nvim_set_hl(0, 'RainbowViolet', { fg = '#8992a7' })
			vim.api.nvim_set_hl(0, 'RainbowCyan', { fg = '#949fb5' }) --teal
		end)

		vim.g.rainbow_delimiters = { highlight = highlight }
		require('ibl').setup( { scope = { highlight = highlight } })
		hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
	end
}
