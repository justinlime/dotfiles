local opt = vim.opt
opt.clipboard = "unnamedplus"
opt.guicursor = "a:blinkon0"
opt.guicursor = "i:ver25-iCursor"
opt.mouse = "a"
opt.smartcase = true
opt.smartindent = true
opt.number = true
opt.relativenumber = true
opt.cursorline = false
opt.wrap = false
opt.shiftwidth = 4
opt.softtabstop = 4
opt.tabstop = 4
opt.backupdir = vim.fn.expand("~/.config/nvim/data/backup")
opt.undodir = vim.fn.expand("~/.config/nvim/data/undo")
opt.directory = vim.fn.expand("~/.config/nvim/data/swap")
opt.ignorecase = true
opt.splitbelow = true
opt.splitright = true
opt.swapfile = false
opt.undofile = true
opt.backup = false
opt.expandtab = true
opt.termguicolors = true
opt.scrolloff = 8
opt.updatetime = 50
opt.cursorline = true
