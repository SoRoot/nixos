vim.api.nvim_set_keymap('n', '<C-p>', ':Files<CR>', {noremap=true, silent=true})
vim.api.nvim_set_keymap('n', '<left>', '<nop>', {noremap=true, silent=true})
vim.api.nvim_set_keymap('n', '<right>', '<nop>', {noremap=true, silent=true})
vim.api.nvim_set_keymap('n', '<up>', '<nop>', {noremap=true, silent=true})
vim.api.nvim_set_keymap('n', '<down>', '<nop>', {noremap=true, silent=true})
vim.api.nvim_set_keymap('n', '<leader>e', ':Lexplore<CR>', {noremap=true, silent=true}) --toggle for Lexplore 
vim.api.nvim_set_keymap('n', '<leader>t', ':TagbarToggle<CR>', {noremap=true, silent=true}) --toggle object hirachy
vim.api.nvim_set_keymap('n', '<leader>v', ':tabedit $MYVIMRC<CR>', {noremap=true, silent=true}) --open vimrc in ohter tap
vim.api.nvim_set_keymap('n', '<leader>l', ':set wrap!<CR>', {noremap=true, silent=true}) --toggle linewrapping
vim.api.nvim_set_keymap('n', '<S-Enter>', 'O<Esc>', {noremap=true, silent=true}) --shift enter => line above
vim.api.nvim_set_keymap('n', '<CR>', 'o<Esc>', {noremap=true, silent=true}) --enter => line below
vim.api.nvim_set_keymap('x', 'p', '_dP ', {noremap=true, silent=true}) --overwrite with yanked text in visual mode

