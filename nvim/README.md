# Justinlime's Neovim Config
![Imgur](https://imgur.com/2gll0Qy.png)
![Imgur](https://imgur.com/00mKFGY.png)
![Imgur](https://imgur.com/MZZSVBI.png)
## Plugins:
```lua
lazy.nvim -- Plugin Manager
indent-blankline.nvim -- Shows indentation lines for easier tracking
nvim-ts-autotag --Automatic tags for HTML, and various other languages
nvim-autopairs --Autoclosing brackets, quotations, parentheses, etc
vim-fugitive --Git commands directly in neovim
gitsigns.nvim --Show git additions, deletions, changes, realtime in the buffer 
transparent.nvim --Toggleable Transparency
Comment.nvim --Easy Line, Multiline, and Section commenting with a keybind
which-key --Shows your available keybinds if you get stuck
toggleterm.nvim --Toggleable terminal for in neovim
nvim-treesitter --Language Parser
nvim-tree.lua --File Explorer
presence.nvim --Discord rich presence integration 
bufferline.nvim --Neovim Tabs
lualine.nvim --Status Bar
telescope --Fuzzy Finder
dashboard.nvim --Dope Dashboard
nvim-lspconfig + nvim-cmp + luasnip --LSP and completion engines with snippets
```
## Colorschemes:
```lua
onedarkpro
dracula
catppuccin
rosepine
toykonight
gruvbox
```

## Requirements:
```lua
--Use appimage version if 0.9 isnt in your repositories
--Or use nix :))))
neovim 0.9 
gcc --Needed for treesitter
```

##  Installation:
```
sh <(curl https://raw.githubusercontent.com/justinlime/dotfiles/main/nvim/install.sh)
```
