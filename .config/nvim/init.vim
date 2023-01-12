:set number
:set mouse=a
:set autoindent
:set tabstop=4
:set softtabstop=4
:set shiftwidth=4
:set smarttab
:set backupdir=~/.config/nvim/.undo
:set undodir=~/.config/nvim/.backup
:set directory=~/.config/nvim/.swp

call plug#begin('~/.config/nvim/plugged')

Plug 'https://github.com/vim-airline/vim-airline'
Plug 'https://github.com/preservim/nerdtree'
Plug 'https://github.com/tpope/vim-surround'
Plug 'https://github.com/tpope/vim-commentary'
Plug 'https://github.com/ap/vim-css-color'
Plug 'https://github.com/rafi/awesome-vim-colorschemes'
Plug 'https://github.com/ryanoasis/vim-devicons'
Plug 'https://github.com/tc50cal/vim-terminal'
Plug 'https://github.com/mg979/vim-visual-multi'

Plug 'https://github.com/preservim/tagbar'
Plug 'https://github.com/neoclide/coc.nvim'

" --- Notes ---
"  :PlugClean cleans removed pluggins from config
"  :UpdateRemotePlugins updates plugins
"
"  :CocInstall coc-python
"
call  plug#end()

let g:NERDTreeDirArrowExpandable="+"
let g:NERDTreeDirArrowCollapsible="-"
let NERDTreeShowHidden=1

:colorscheme minimalist

"Ctrl+d for NerdTree
nnoremap <C-d> :NERDTreeToggle<CR>
"Ctrl+x for Tagbar
nmap <C-x> :TagbarToggle <CR>
"Tab to trigger autocomplete
inoremap <expr> <Tab> pumvisible() ? coc#_select_confirm() : "<Tab>"
" Tab Naigation
map <C-h> :tabp<CR>
map <C-l> :tabn<CR>
map <C-;> :tabnew<CR>
map <C-'> :tabclose<CR>

