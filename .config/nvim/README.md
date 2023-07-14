My neovim config

![Imgur Image](https://imgur.com/Jy49zJT.png)
![Imgur](https://imgur.com/YrT4gxf.png)
Plugins:
```lua
lazy.nvim -- Plugin Manager
indent-blankline.nvim -- Shows indentation lines for easier tracking
nvim-ts-autotag --Automatic tags for HTML, and various other languages
vim-fugitive --Git Add,Commit,Push, and everything else all from neovim
transparent.nvim --Toggleable Transparency
Comment.nvim --Easy Line, Multiline, and Section commenting with a keybind
which-key --Shows your available keybinds if you get stuck
nvim-treesitter --Language Parser
nvim-tree.lua --File Explorer
bufferline.nvim --Neovim Tabs
lualine.nvim --Status Bar
telescope --Fuzzy Finder, instantly find a file
dashboard.nvim --Dope Dashboard
lsp-zero --Easy LSP support, Easy installation of LSP Servers from mason menu
```
Colorschemes:
```lua
onedarkpro
dracula
catppuccin
rosepine
toykonight
gruvbox
```

Requirements:
```lua
neovim 0.9 --Use appimage version if 0.9 isnt in your repositories
gcc
tar
curl
git
wget
unzip
gzip
```

Installation:
First, just clone the repo
```
git clone https://github.com/justinlime/dotfiles
```
Then CD into the dotfiles/.config/nvim and run  
```
./install.sh
```

