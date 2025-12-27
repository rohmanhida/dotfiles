vim.o.clipboard = 'unnamedplus'
vim.o.linebreak = true
vim.o.mouse = 'a'
vim.o.autoindent = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.expandtab = true
vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.shiftwidth = 2
vim.wo.number = true
vim.relativenumber = true
vim.o.termguicolors = true

vim.g.mapleader = " "

-- additional config from henry misc
vim.o.hlsearch = false -- Set highlight on search
vim.o.breakindent = true -- Enable break indent
vim.o.undofile = true -- Save undo history
vim.wo.signcolumn = 'yes' -- Keep signcolumn on by default
vim.o.backup = false -- creates a backup file
vim.o.writebackup = false -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
vim.o.completeopt = 'menuone,noselect' -- Set completeopt to have a better completion experience
vim.o.whichwrap = 'bs<>[]hl' -- which "horizontal" keys are allowed to travel to prev/next line
vim.o.wrap = false -- display lines as one long line
vim.o.scrolloff = 4 -- minimal number of screen lines to keep above and below the cursor
vim.o.sidescrolloff = 8 -- minimal number of screen columns either side of cursor if wrap is `false`
vim.o.relativenumber = true -- set relative numbered lines
vim.o.cursorline = true -- highlight the current line
vim.o.splitbelow = true -- force all horizontal splits to go below current window
vim.o.splitright = true -- force all vertical splits to go to the right of current window
vim.o.swapfile = false -- creates a swapfile
vim.o.smartindent = true -- make indenting smarter again
vim.o.showmode = false -- we don't need to see things like -- INSERT -- anymore
vim.o.showtabline = 1 -- always show tabs
vim.o.backspace = 'indent,eol,start' -- allow backspace on
vim.o.pumheight = 10 -- pop up menu height
vim.o.conceallevel = 0 -- so that `` is visible in markdown files
vim.o.fileencoding = 'utf-8' -- the encoding written to a file
vim.o.cmdheight = 1 -- more space in the neovim command line for displaying messages
vim.o.autoindent = true -- copy indent from current line when starting new one
vim.opt.shortmess:append 'c' -- don't give |ins-completion-menu| messages
-- vim.opt.iskeyword:append '-' -- hyphenated words recognized by searches
vim.opt.formatoptions:remove { 'c', 'r', 'o' } -- don't insert the current comment leader automatically for auto-wrapping comments using 'textwidth', hitting <Enter> in insert mode, or hitting 'o' or 'O' in normal mode.
vim.opt.runtimepath:remove '/usr/share/vim/vimfiles' -- separate vim plugins from neovim in case vim still in use

-- diagnostics
vim.diagnostic.config({
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "",
      [vim.diagnostic.severity.WARN]  = "",
      [vim.diagnostic.severity.HINT]  = "󰠠",
      [vim.diagnostic.severity.INFO]  = "",
    },
  },
})
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = '[E]rror' })

-- Check if colorscheme is nord and background is light
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "nord",
  callback = function()
    if vim.o.background == "light" then
      vim.api.nvim_set_hl(0, "Visual", { bg = "#c5cbd8" })
    end
  end,
})
