local status, plugin = pcall(require,'transparent')
if not status then
    print('Plugin Error: ', plugin)
    return
end
plugin.setup({
  groups = { -- table: default groups
    'Normal', 'NormalNC', 'Comment', 'Constant', 'Special', 'Identifier',
    'Statement', 'PreProc', 'Type', 'Underlined', 'Todo', 'String', 'Function',
    'Conditional', 'Repeat', 'Operator', 'Structure', 'LineNr', 'NonText',
    'SignColumn', 'CursorLineNr', 'EndOfBuffer',
  },
  extra_groups = {
    "NormalFloat", -- plugins which have float panel such as Lazy, Mason, LspInfo
    "NvimTreeNormal", -- NvimTree
    "NvimTreeNormalNC",
    "NvimTreeWinSeparator",
    "TelescopeNormal",
    "TelescopeBorder",
    "WhichKeyFloat",
  }, -- table: additional groups that should be cleared
  exclude_groups = {}, -- table: groups you don't want to clear
})
vim.g.transparent_groups = vim.list_extend(
  vim.g.transparent_groups or {},
  vim.tbl_map(function(v)
    return v.hl_group
  end, vim.tbl_values(require('bufferline.config').highlights))
)

--- Fix for bufferline looking strange on startup ---
vim.cmd(":TransparentToggle")
vim.cmd(":TransparentToggle")

