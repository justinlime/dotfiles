set relativenumber
set number
set mouse=r
set autoindent
set tabstop=4
set nowrap
set softtabstop=4
set shiftwidth=4
set smarttab
set clipboard^=unnamed,unnamedplus
set undodir=~/.config/vim/.undo
set directory=~/.config/vim/.swp
set splitbelow
set splitright
set noswapfile
set undofile
set nobackup
set nocursorline
set smartindent
set smartcase
set termguicolors
set expandtab
set scrolloff=8
set updatetime=50
set expandtab
set guicursor=""
set ignorecase
set cursorline
syntax enable

:hi CursorLineNr ctermbg=black term=none cterm=none guibg=Grey20
:hi CursorLine ctermbg=black term=none cterm=none guibg=Grey20
:hi Visual guibg=Grey20

"Leader Key <Space>
:noremap <Space> <Nop>
let mapleader=" "
let localleader=" "

""""" Normal Mode 

"Window Resize
:nnoremap <S-h> :vertical resize -2<CR>
:nnoremap <S-j> :resize -2<CR>
:nnoremap <S-k> :resize +2<CR>
:nnoremap <S-l> :vertical resize +2<CR>

""""" Insert Mode

"Navigation and Escape
:inoremap jj <ESC>

""""" Visual Mode

"Move Selections
:vnoremap <S-h> < gv
:vnoremap <S-j> :m '>+1<CR>gv=gv
:vnoremap <S-k> :m '<-2<CR>gv=gv
:vnoremap <S-l> > gv

""""" File Explorer
"Open Lex file explorer
:nnoremap <leader>d :Lex 20<CR>

