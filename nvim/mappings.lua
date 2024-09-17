vim.api.nvim_set_keymap('n', '<left>', '<nop>', {noremap=true, silent=true}) --disable arrows to use only hjkl
vim.api.nvim_set_keymap('n', '<right>', '<nop>', {noremap=true, silent=true})
vim.api.nvim_set_keymap('n', '<up>', '<nop>', {noremap=true, silent=true})
vim.api.nvim_set_keymap('n', '<down>', '<nop>', {noremap=true, silent=true})
vim.api.nvim_set_keymap('n', '<leader>e', ':Lexplore<CR>', {noremap=true, silent=true}) --toggle for Lexplore 
vim.api.nvim_set_keymap('n', '<leader>t', ':TagbarToggle<CR>', {noremap=true, silent=true}) --toggle object hirachy
--vim.api.nvim_set_keymap('n', '<leader>v', ':tabedit $MYVIMRC<CR>', {noremap=true, silent=true}) --open vimrc in ohter tap
vim.api.nvim_set_keymap('n', '<leader>l', ':set wrap!<CR>', {noremap=true, silent=true}) --toggle linewrapping
vim.api.nvim_set_keymap('n', '<S-Enter>', 'O<Esc>', {noremap=true, silent=true}) --shift enter => line above
vim.api.nvim_set_keymap('n', '<CR>', 'o<Esc>', {noremap=true, silent=true}) --enter => line below
vim.api.nvim_set_keymap('x', 'p', '_dP ', {noremap=true, silent=true}) --overwrite with yanked text in visual mode

--FZFlua mappings
vim.api.nvim_set_keymap('n', '<leader>F', ':FzfLua git_files<CR>', {noremap=true, silent=true}) --show git files
vim.api.nvim_set_keymap('n', '<leader>f', ':FzfLua files<CR>', {noremap=true, silent=true}) --show files
vim.api.nvim_set_keymap('n', '<leader>b', ':FzfLua buffers<CR>', {noremap=true, silent=true}) --show buffers
vim.api.nvim_set_keymap('n', '<leader>q', ':FzfLua quickfix<CR>', {noremap=true, silent=true}) --show Quickfix
vim.api.nvim_set_keymap('n', '<leader>G', ':FzfLua live_grep<CR>', {noremap=true, silent=true}) --show Live Grep

--Git mappings
vim.api.nvim_set_keymap('n', '<leader>gb', ':Gitsigns blame_line<CR>', {noremap=true, silent=true})
vim.api.nvim_set_keymap('n', '<leader>gs', ':Gitsigns stage_hunk<CR>', {noremap=true, silent=true})
vim.api.nvim_set_keymap('n', '<leader>gu', ':Gitsigns undo_stage_hunk<CR>', {noremap=true, silent=true})
vim.api.nvim_set_keymap('n', '<leader>gr', ':Gitsigns reset_hunk<CR>', {noremap=true, silent=true})
vim.api.nvim_set_keymap('n', '<leader>gR', ':Gitsigns reset_buffer<CR>', {noremap=true, silent=true})
vim.api.nvim_set_keymap('n', '<leader>gp', ':Gitsigns preview_buffer<CR>', {noremap=true, silent=true})

--Code (LSP)


--spell mappings: change the last wrong wirtten word with ,+f undo with esc+u.
vim.api.nvim_set_keymap('i', '<leader>r', '<c-g>u<Esc>[s1z=`]a<c-g>u', {noremap=true, silent=true}) --for insert mode
vim.api.nvim_set_keymap('n', '<leader>r', '[s1z=<c-o>', {noremap=true, silent=true}) --and normal mode

-- Indent lines and reselect visual group
vim.api.nvim_set_keymap('n', '<', '<gv', {noremap=true, silent=true})
vim.api.nvim_set_keymap('n', '>', '>gv', {noremap=true, silent=true})
vim.api.nvim_set_keymap('v', '<', '<gv', {noremap=true, silent=true})
vim.api.nvim_set_keymap('v', '>', '>gv', {noremap=true, silent=true})
