set number
set mouse=a
set autoindent
set tabstop=4
set softtabstop=4
set shiftwidth=4
set smarttab
set clipboard=unnamedplus
set nowrap
set undodir=~/.conifg/vim/.undo
set directory=~/.config/vim/.swp
set splitbelow
set splitright
set noswapfile
set undofile
set nobackup
set nocursorline
set smartindent

"Leader Key
let mapleader=" "
let localleader=" "

""""" Normal Mode 

"Write and Quit
:nnoremap <leader>wq :wq<CR>
:nnoremap <leader>q :q<CR>
:nnoremap <leader>qq :q!<CR>
:nnoremap <leader>w :w<CR>

"Window Nav
:nnoremap <A-h> <C-w>h
:nnoremap <A-j> <C-w>j
:nnoremap <A-k> <C-w>k
:nnoremap <A-l> <C-w>l

""""" Insert Mode

" Navigation and Escape
:inoremap jkjk <ESC>
:inoremap <A-h> <Left>
:inoremap <A-j> <Down>
:inoremap <A-k> <Up>
:inoremap <A-l> <Right>









