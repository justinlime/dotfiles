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

" Leader Key <Space>
:noremap <Space> <Nop>
let mapleader=" "
let localleader=" "

""""" Normal Mode 

" Window Spawn
:nnoremap <A-v> <C-w>s
:nnoremap <A-b> <C-w>v

" Window Nav
:nnoremap <A-h> <C-w>h
:nnoremap <A-j> <C-w>j
:nnoremap <A-k> <C-w>k
:nnoremap <A-l> <C-w>l

" Window Resize
:nnoremap <S-h> :vertical resize -2<CR>
:nnoremap <S-j> :resize -2<CR>
:nnoremap <S-k> :resize +2<CR>
:nnoremap <S-l> :vertical resize +2<CR>

""""" Insert Mode

" Navigation and Escape
:inoremap jj <ESC>
:inoremap <A-h> <Left>
:inoremap <A-j> <Down>
:inoremap <A-k> <Up>
:inoremap <A-l> <Right>

""""" Visual Mode

" Move Selections
:vnoremap <A-h> < gv
:vnoremap <A-j> :m '>+1<CR>gv=gv
:vnoremap <A-k> :m '<-2<CR>gv=gv
:vnoremap <A-l> > gv






