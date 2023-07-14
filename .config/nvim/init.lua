--- Plugin Manager ---
require(".lazy")

--- Colorschemes ---
vim.cmd("runtime! lua/plugins/colorschemes/*.lua")

--- All Core Files ---
vim.cmd("runtime! lua/core/*.lua")

--- All  Other Plugins ---
vim.cmd("runtime! lua/plugins/*.lua")

