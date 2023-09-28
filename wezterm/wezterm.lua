local wezterm = require 'wezterm';
return {
	--default_prog = {"C:/Windows/System32/WindowsPowerShell/v1.0/powershell.exe"},
	--default_prog = {"C:/Users/lukas/AppData/Local/Microsoft/WindowsApps/ubuntu2004.exe"},
	hide_tab_bar_if_only_one_tab = true;
	--colors = {
            --background = "#012456",
            --foreground = "#EEEDF0",


            --black = "#000000",
            --blue = "#000080",
            --brightBlack = "#808080",
            --brightBlue = "#0000FF",
            --brightCyan = "#00FFFF",
            --brightGreen = "#00FF00",
            --brightPurple = "#FF00FF",
            --brightRed = "#FF0000",
            --brightWhite = "#FFFFFF",
            --brightYellow = "#FFFF00",
            --cursorColor = "#FFFFFF",
            --cyan = "#008080",
            --green = "#008000",
            --purple = "#012456",
            --red = "#800000",
            --white = "#C0C0C0",
            --yellow = "#EEEDF0",
	--}
	--color_scheme = "Monokai Vivid",
	--color_scheme = "Mathias",
	--color_scheme = "VibranktInk",
	--color_scheme = "Argonaut",
	--color_scheme = "Adventure",
	--color_scheme = "deep",
	color_scheme = "JetBrains Dracula",
	--color_scheme = "Kibble",
	--color_scheme = "PaulMillr",
	--color_scheme = "Symfonic",
	--color_scheme = "synthwave",
	--color_scheme = "Tommorrow Night Bright",
	--color_scheme = "UltraDark",
	--color_scheme = "Thayer Bright",
	--font = wezterm.font({family='DejaVu Sans Mono', stretch="Normal", weight="Regular"}),
	font = wezterm.font_with_fallback {
		'Hack',
		'Font Awesome',
	},
	--font = wezterm.font('Monaco'),
	font_size = 9.0,
}

