# Configs-Rice
My configs and dot files

## Setup

install `sway`

install `swaylock`

install `swayidle`

Might have do download `sddm` if sway is blackscreen when you login

then enable with `sudo systemctl enable sddm -f`

## Applications

install `waybar`

install `wofi` for sexy launcher

install `pavucontrol` for audio device control

install `grim` and `slup` for screenshots

install `gvfs` and `gvfs-smb` for smb

install `azote` for Wallpapers

install `light` for backlight controls

move `autotiling` to $PATH for master stacking tiling

## Theme

add line `export QT_QPA_PLATFORMTHEME=qt5ct` to `/etc/environment` to get QT Themes to work

install `lxappearance` for GTK themes

install `qt5ct` for QT Themes

restart after installing `qt5ct` and `lxappearance`

unzip `Dracula.zip` in `.icons` and `.themes`

## SSH

copy `.terminfo` into remote machine $HOME to support foot

put `set clipboard=unnamed` in remote machines `.vimrc` if copy/paste is an issue

## NeoVim

install vim-plug for plugins

use `:PlugInstall` to install plugins from already set in `.config/nvim/init.vim`

`exuberant c-tags` needed for tagbar plguin

`nodejs` and `npm` is needed for COC (Completion) 

`sudo npm install -g yarn`  then `yarn install` followed by `yarn build` in the `~/.config/nvim/plugged/coc.nvim` folder

`:CocInstall coc-python` for python, similar for other languages






