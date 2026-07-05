local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- Theme / font
config.color_scheme = "Tokyo Night Storm"
config.font = wezterm.font("Hack Nerd Font")
config.font_size = 15

-- Cursor
config.default_cursor_style = "BlinkingBar"
config.cursor_blink_rate = 700

-- Window
config.initial_cols = 135
config.initial_rows = 38
config.window_background_opacity = 0.6
config.win32_system_backdrop = "Acrylic"
config.window_decorations = "RESIZE"
config.window_padding = {
	left = 10,
	right = 10,
	top = 10,
	bottom = 10,
}
config.window_frame = {
	font = wezterm.font("Hack Nerd Font", { weight = "Bold" }),
	font_size = 12.0,
}

-- Tab bar
config.enable_scroll_bar = false
config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = false
config.show_new_tab_button_in_tab_bar = true
config.tab_bar_at_bottom = false

-- Colors (cursor + tab bar merged into ONE table)
config.colors = {
	cursor_bg = "#7aa2f7",
	cursor_fg = "#1a1b26",
	cursor_border = "#7aa2f7",
	tab_bar = {
		background = "#1a1b26",
		active_tab = {
			bg_color = "#7aa2f7",
			fg_color = "#1a1b26",
		},
		inactive_tab = {
			bg_color = "#24283b",
			fg_color = "#7aa2f7",
		},
		inactive_tab_hover = {
			bg_color = "#414868",
			fg_color = "#c0caf5",
		},
		new_tab = {
			bg_color = "#1a1b26",
			fg_color = "#7aa2f7",
		},
		new_tab_hover = {
			bg_color = "#414868",
			fg_color = "#ffffff",
		},
	},
}

-- Performance
config.front_end = "WebGpu"
config.max_fps = 144
config.animation_fps = 144
config.scrollback_lines = 100000

-- Keybindings (all merged into ONE table)
config.keys = {
	{
		key = "v",
		mods = "CTRL",
		action = wezterm.action.PasteFrom("Clipboard"),
	},
	{
		key = "c",
		mods = "CTRL|SHIFT",
		action = wezterm.action.CopyTo("Clipboard"),
	},
	{
		key = "t",
		mods = "CTRL|SHIFT",
		action = wezterm.action.SpawnTab("CurrentPaneDomain"),
	},
	{
		key = "u",
		mods = "CTRL|SHIFT",
		action = wezterm.action.SpawnCommandInNewTab({
			args = { "wsl.exe", "~", "-d", "Ubuntu" },
		}),
	},
}

return config