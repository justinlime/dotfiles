local opts = { noremap = true, silent = true }

local term_opts = { silent = true }

local map = vim.api.nvim_set_keymap

--Leader Key
map("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "



---------- Normal Mode ----------

--Window Nav
map("n", "<A-h>", "<C-w>h", opts)
map("n", "<A-j>", "<C-w>j", opts)
map("n", "<A-k>", "<C-w>k", opts)
map("n", "<A-l>", "<C-w>l", opts)

--Window Spawn
map("n", "<A-v>", "<C-w>s", opts)
map("n", "<A-b>", "<C-w>v", opts)

--Window Resize
map("n", "<S-h>", ":vertical resize -2<CR>", opts)
map("n", "<S-j>", ":resize -2<CR>", opts)
map("n", "<S-k>", ":resize +2<CR>", opts)
map("n", "<S-l>", ":vertical resize +2<CR>", opts)



---------- Insert Mode ----------

--Navigation
map("i", "jj", "<ESC>", opts)
map("i", "<A-h>", "<Left>", opts)
map("i", "<A-j>", "<Down>", opts)
map("i", "<A-k>", "<Up>", opts)
map("i", "<A-l>", "<Right>", opts)



---------- Visual Mode ----------

--Move Selections
map("v", "<A-h>", "< gv", opts) 
map("v", "<A-j>", ":m '>+1<CR>gv=gv", opts)
map("v", "<A-k>", ":m '<-2<CR>gv=gv", opts)
map("v", "<A-l>", "> gv", opts)
