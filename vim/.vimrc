" Basic settings
set clipboard=unnamedplus
set linebreak
set mouse=a
set autoindent
set ignorecase
set smartcase
set expandtab
set tabstop=2
set softtabstop=2
set shiftwidth=2
set number
set relativenumber
set termguicolors
let mapleader = " "

" Additional config
set nohlsearch            " Disable highlight search
set breakindent           " Enable break indent
set undofile              " Save undo history
set signcolumn=yes        " Keep signcolumn on by default
set nobackup              " Don't create backup files
set nowritebackup         " Don't edit files being edited by another program
set completeopt=menuone,noselect  " Better completion experience
set termguicolors         " Enable highlight groups
set whichwrap=bs<>[]hl    " Allow horizontal keys to travel to prev/next line
set nowrap                " Don't wrap lines
set scrolloff=4           " Keep 4 lines visible above/below cursor
set sidescrolloff=8       " Keep 8 columns visible on sides of cursor
set relativenumber        " Relative line numbers
set cursorline            " Highlight current line
set splitbelow            " Horizontal splits go below
set splitright            " Vertical splits go right
set noswapfile            " Don't create swap files
set smartindent           " Smart indentation
set showmode              " Don't show -- INSERT -- etc.
set showtabline=1         " Show tabline when needed
set backspace=indent,eol,start  " Allow backspace on various elements
set pumheight=10          " Pop-up menu height
set conceallevel=0        " Make markdown visible
set fileencoding=utf-8    " File encoding
set cmdheight=1           " Command line height
set autoindent            " Auto indent new lines

" Special option handling
set shortmess+=c          " Don't give completion menu messages
set iskeyword+=-          " Treat hyphenated words as one word

" Format options - disable auto commenting on new lines
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" Remove specific runtime path (may not work exactly in standard Vim)
" set runtimepath-=/usr/share/vim/vimfiles

call plug#begin()
" List your plugins here
Plug 'morhetz/gruvbox'
call plug#end()
set background=dark
colorscheme gruvbox
