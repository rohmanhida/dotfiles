return {
  "christoomey/vim-tmux-navigator",
  config = function()
    -- Define keymappings for tmux navigation
    vim.keymap.set('n', '<C-h>', '<cmd>TmuxNavigateLeft<CR>', { noremap = true, silent = true, desc = "Navigate left (tmux aware)" })
    vim.keymap.set('n', '<C-j>', '<cmd>TmuxNavigateDown<CR>', { noremap = true, silent = true, desc = "Navigate down (tmux aware)" })
    vim.keymap.set('n', '<C-k>', '<cmd>TmuxNavigateUp<CR>', { noremap = true, silent = true, desc = "Navigate up (tmux aware)" })
    vim.keymap.set('n', '<C-l>', '<cmd>TmuxNavigateRight<CR>', { noremap = true, silent = true, desc = "Navigate right (tmux aware)" })
  end
}
