vim.o.scrolloff=5 --show lines above and below when scrolling
vim.o.autoindent=true --copy the indentation from the previous lines
vim.o.backspace="indent,eol,start" --make backspace work like most other programs
vim.o.cursorline=true --highlight current line
vim.o.history=50 --keep 50 lines of command line history
vim.o.hlsearch=true --highlight matches
vim.o.ignorecase=true --case insensitive search
vim.o.smartcase=true --case sensitive then capital is typed
vim.o.incsearch=true --search as characters are entered
vim.o.laststatus=2 --always show the status line
vim.o.lazyredraw=true --redraw only when we need to
vim.o.number=true --how line numbers
vim.o.ruler=true --show the cursor position in status line
vim.o.showcmd=true --displays editor commands in command line
vim.o.synmaxcol=250 --maximum length of syntax highlighting
vim.o.wildmenu=true --completes commands in command line
vim.o.wrapscan=true --wrap when searching to beginning
vim.o.clipboard="unnamedplus" --using linux clipboard
vim.o.tabstop=2 --tap is only 2 spaces 
vim.o.shiftwidth=2 --tap 2
vim.o.foldmethod="syntax" --folding based on syntax
vim.o.foldlevelstart=20 --closed fold only ober 20
vim.o.modeline=true --enabel custimized modeline methods
vim.o.mouse="a" --enable use of the mouse for all modes - helpful for resizing buffers
--vim.o.mouse="" --disable vim mouse, using default terminal mouse support for working on servers
--change cursor shape depending on mode
vim.o.guicursor="n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor,sm:block-blinkwait175-blinkoff150-blinkon175"

vim.opt.spell=true --mandatory seetings for cmp-spell
vim.opt.spelllang={'en_us'} --set lang for cmp-spell

vim.g.mapleader=","
vim.g.netrw_liststyle=3 --shows 3rd liststyle in explorer mode
vim.g.netrw_altv=1 --open files on right
vim.g.netrw_winsize = 20 --winsize of netrw

-- jump to last position after closing
local group = vim.api.nvim_create_augroup("jump_last_position", { clear = true })
vim.api.nvim_create_autocmd(
	"BufReadPost",
	{callback = function()
			local row, col = unpack(vim.api.nvim_buf_get_mark(0, "\""))
			if {row, col} ~= {0, 0} then
				vim.api.nvim_win_set_cursor(0, {row, 0})
			end
		end,
	group = group
	}
)

require('gitsigns').setup{} --gitsign plugin to show git changes in file
