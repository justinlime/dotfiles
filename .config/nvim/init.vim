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

" Install vim-plug here https://github.com/junegunn/vim-plug
call plug#begin('~/.config/nvim/plugged')

" No Dependancies
Plug 'https://github.com/vim-airline/vim-airline'
Plug 'https://github.com/preservim/nerdtree'
Plug 'https://github.com/tpope/vim-commentary'
Plug 'https://github.com/ap/vim-css-color'
Plug 'https://github.com/rafi/awesome-vim-colorschemes'
Plug 'https://github.com/mg979/vim-visual-multi'
Plug 'https://github.com/nvim-lua/plenary.nvim.git'
Plug 'https://github.com/nvim-treesitter/nvim-treesitter.git'
Plug 'https://github.com/lewis6991/gitsigns.nvim.git'
Plug 'https://github.com/windwp/nvim-autopairs'
Plug 'https://github.com/lukas-reineke/indent-blankline.nvim.git'

"Has Dependancies
Plug 'https://github.com/ryanoasis/vim-devicons' "Requires a Nerd Font in .fonts directory
Plug 'https://github.com/nvim-telescope/telescope.nvim.git' "Requires plenary.nvim plugin
Plug 'https://github.com/preservim/tagbar' "Requires ctags installed

call  plug#end()

:colorscheme minimalist

" --- Notes ---
"  :PlugInstall to install listed plugins from config
"  :PlugClean cleans removed pluggins from config
"  
"
"  :CocInstall coc-python
"
let g:NERDTreeDirArrowExpandable="+"
let g:NERDTreeDirArrowCollapsible="-"
let NERDTreeShowHidden=1

"
nnoremap <f-f> :Telescope find_files<cr>
"Ctrl+d for NerdTree
nnoremap <C-d> :NERDTreeToggle<CR>
"Ctrl+x for Tagbar
nmap <C-x> :TagbarToggle<CR>
"Tab to trigger autocomplete
inoremap <expr> <Tab> pumvisible() ? coc#_select_confirm() : "<Tab>"
" Ctrl+h previous tab
" Ctrl+l next tab
" Ctrl+; new tab 
" Ctrl+' close tab
map <C-h> :tabp<CR>
map <C-l> :tabn<CR>
map <C-;> :tabnew<CR>
map <C-'> :tabclose<CR>


