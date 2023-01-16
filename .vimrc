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






