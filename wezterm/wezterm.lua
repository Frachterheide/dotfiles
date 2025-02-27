local wezterm = require('wezterm')
local config = wezterm.config_builder()
config.enable_wayland = true
config.keys = {
	{
		key = "1",
		mods = "CTRL",
		action = wezterm.action.SendString("\x1b[49;5u"),
	},
	{
		key = "2",
		mods = "CTRL",
		action = wezterm.action.SendString("\x1b[50;5u"),
	},
	{
		key = "3",
		mods = "CTRL",
		action = wezterm.action.SendString("\x1b[51;5u"),
	},
	{
		key = "4",
		mods = "CTRL",
		action = wezterm.action.SendString("\x1b[52;5u"),
	},
	{
		key = "5",
		mods = "CTRL",
		action = wezterm.action.SendString("\x1b[53;5u"),
	},
	{
		key = "6",
		mods = "CTRL",
		action = wezterm.action.SendString("\x1b[54;5u"),
	},
	{
		key = "7",
		mods = "CTRL",
		action = wezterm.action.SendString("\x1b[55;5u"),
	},
	{
		key = "8",
		mods = "CTRL",
		action = wezterm.action.SendString("\x1b[56;5u"),
	},
	{
		key = "9",
		mods = "CTRL",
		action = wezterm.action.SendString("\x1b[57;5u"),
	},
	{
		key = ",",
		mods = "CTRL",
		action = wezterm.action.SendString("\x1b[44;5u"),
	},
}
config.font = wezterm.font 'Jetbrains Mono'
config.font_size = 14.0
config.force_reverse_video_cursor = true
config.colors = {
	foreground = "#dcd7ba",
	background = "#1f1f28",

	cursor_bg = "#c8c093",
	cursor_fg = "#c8c093",
	cursor_border = "#c8c093",

	selection_fg = "#c8c093",
	selection_bg = "#2d4f67",

	scrollbar_thumb = "#16161d",
	split = "#16161d",

	ansi = { "#090618", "#c34043", "#76946a", "#c0a36e", "#7e9cd8", "#957fb8", "#6a9589", "#c8c093" },
	brights = { "#727169", "#e82424", "#98bb6c", "#e6c384", "#7fb4ca", "#938aa9", "#7aa89f", "#dcd7ba" },
	indexed = { [16] = "#ffa066", [17] = "#ff5d62" },
}
return config
