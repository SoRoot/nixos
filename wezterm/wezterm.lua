local wezterm = require 'wezterm';
return {
	--default_prog = {"C:/Windows/System32/WindowsPowerShell/v1.0/powershell.exe"},
	--default_prog = {"C:/Users/lukas/AppData/Local/Microsoft/WindowsApps/ubuntu2004.exe"},
	hide_tab_bar_if_only_one_tab = true;
	--color_scheme = "Monokai Vivid",
	--color_scheme = "Mathias",
	color_scheme = "Dracula",
	--color_scheme = "VibranktInk",
	--color_scheme = "Argonaut",
	--color_scheme = "Adventure",
	--color_scheme = "deep",
	--color_scheme = "JetBrains Dracula",
	--color_scheme = "Kibble",
	--color_scheme = "PaulMillr",
	--color_scheme = "Symfonic",
	--color_scheme = "synthwave",
	--color_scheme = "Tommorrow Night Bright",
	--color_scheme = "UltraDark",
	--color_scheme = "Thayer Bright",
	--font = wezterm.font('Monaco'),
	font = wezterm.font_with_fallback {
		'Hack',
		'Font Awesome 6 Free',
		'Nerd Font',
		'Noto Sans Mono',
	},
	font_size = 9.0,
}

