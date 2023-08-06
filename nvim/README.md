# Justinlime's Neovim Config

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
--Use appimage version if 0.9 isnt in your repositories
--Or use nix :))))
neovim 0.9 
gcc
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

