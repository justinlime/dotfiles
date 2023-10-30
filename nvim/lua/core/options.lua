local opt = vim.opt
opt.clipboard = "unnamedplus"
opt.guicursor = "a:blinkon0" --Disable cursor blink
opt.guicursor = "i:ver25-iCursor" --Change to beam cursor when in insert mode
opt.mouse = "a"
opt.smartcase = true
opt.smartindent = true
opt.number = true
opt.relativenumber = true
opt.cursorline = false
opt.cursorlineopt='number'
opt.wrap = false
opt.shiftwidth = 4
opt.softtabstop = 4
opt.tabstop = 4
opt.backupdir = vim.fn.expand("~/.local/share/nvim/data/backup")
opt.undodir = vim.fn.expand("~/.local/share/nvim/data/undo")
opt.directory = vim.fn.expand("~/.local/share/nvim/data/swap")
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
vim.api.nvim_create_autocmd("FileType", { --Set indentation to 2 spaces for nix files
	pattern = "nix",
	command = "setlocal shiftwidth=2 tabstop=2"
})
