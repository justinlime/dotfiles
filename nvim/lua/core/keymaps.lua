local opts = { noremap = true, silent = true }
local map = vim.keymap.set

--Leader Key
map("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

---------- Normal Mode ----------

--Window Resize
map("n", "<S-h>", ":vertical resize +2<CR>", opts)
map("n", "<S-j>", ":resize +2<CR>", opts)
map("n", "<S-k>", ":resize -2<CR>", opts)
map("n", "<S-l>", ":vertical resize -2<CR>", opts)

---------- Insert Mode ----------

--jj gang rise up
map("i", "jj", "<ESC>", opts)

---------- Visual Mode -----------

--Move Selections
map("v", "<S-h>", "< gv", opts)
map("v", "<S-j>", ":m '>+1<CR>gv=gv", opts)
map("v", "<S-k>", ":m '<-2<CR>gv=gv", opts)
map("v", "<S-l>", "> gv", opts)

---------- Terminal Mode ----------

--Escape Terminal
map('t', 'jj', [[<C-\><C-n>]], opts)
map('t', '<C-[>', [[<C-\><C-n>]], opts)
map('t', '<esc>', [[<C-\><C-n>]], opts)

--------- Custom Functions ----------

--Edit Nvim
map("n", "<leader>en", ":lua edit_nvim()<CR>", opts)

---------- Plugins ----------------

--Fugative
map("n", "<leader>ga", ":G add<Space>", opts)
map("n", "<leader>gs", ":G status<CR>", opts)
map("n", "<leader>gb", ":G branch<Space>", opts)
map("n", "<leader>gm", ":G merge<Space>", opts)
map("n", "<leader>gpl", ":G pull<Space>", opts)
map("n", "<leader>gplo", ":G pull origin<Space>", opts)
map("n", "<leader>gps", ":G push<Space>", opts)
map("n", "<leader>gpso", ":G push origin<Space>", opts)
map("n", "<leader>gc", ":G commit<Space>", opts)
map("n", "<leader>gcm", ":G commit -m<Space>", opts)
map("n", "<leader>gch", ":G checkout<Space>", opts)
map("n", "<leader>gchb", ":G checkout -b<Space>", opts)
map("n", "<leader>gcoe", ":G config user.email<Space>", opts)
map("n", "<leader>gcon", ":G config user.name<Space>", opts)

--Nvim Tree
map("n", "<leader>dt", ":NvimTreeToggle<CR>", opts)

--Transparency
map("n", "<leader>tt", ":TransparentToggle<CR>", opts)

--Telescope
map('n', '<leader>ff', ":Telescope find_files<CR>", opts)
map('n', '<leader>fw', ":Telescope live_grep<CR>", opts)
map('n', '<leader>fgc', ":Telescope git_commits<CR>", opts)
map('n', '<leader>fgs', ":Telescope git_stash<CR>", opts)
map('n', '<leader>fgb', ":Telescope git_branches<CR>", opts)
map('n', '<leader>fv', ":Telescope treesitter<CR>", opts)
map('n', '<leader>fs', ":Telescope spell_suggest<CR>", opts)
map('n', '<leader>fc', ":Telescope colorscheme<CR>", opts)

--BufferLine
map("n", "<leader>1", ":BufferLineGoToBuffer 1<CR>", opts)
map("n", "<leader>2", ":BufferLineGoToBuffer 2<CR>", opts)
map("n", "<leader>3", ":BufferLineGoToBuffer 3<CR>", opts)
map("n", "<leader>4", ":BufferLineGoToBuffer 4<CR>", opts)
map("n", "<leader>5", ":BufferLineGoToBuffer 5<CR>", opts)
map("n", "<leader>6", ":BufferLineGoToBuffer 6<CR>", opts)
map("n", "<leader>7", ":BufferLineGoToBuffer 7<CR>", opts)
map("n", "<leader>8", ":BufferLineGoToBuffer 8<CR>", opts)
map("n", "<leader>9", ":BufferLineGoToBuffer 9<CR>", opts)

map("n", "<leader>h", ":BufferLineCyclePrev<CR>", opts)
map("n", "<leader>l", ":BufferLineCycleNext<CR>", opts)

map("n", "<leader><S-h>", ":BufferLineMovePrev<CR>", opts)
map("n", "<leader><S-l>", ":BufferLineMoveNext<CR>", opts)

map("n", "<leader>qq", ":bdelete<CR>", opts) -- Close current buffer
