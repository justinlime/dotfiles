local status, plugin = pcall(require,'lualine')
if not status then
    print('Error with plugin: ', plugin)
    return
end

local colors = {
    darkgray = "#16161d",
    gray = "#727169",
    innerbg = nil,
    outerbg = nil,
    normal = "#bd93f9",
    insert = "#7e9cd8",
    visual = "#ffa066",
    replace = "#e46876",
    command = "#e6c384",
}
local custom_theme = {
    inactive = {
        a = { fg = colors.gray, bg = colors.outerbg, gui = "bold" },
        b = { fg = colors.gray, bg = colors.outerbg },
        c = { fg = colors.gray, bg = colors.innerbg },
    },
    visual = {
        a = { fg = colors.darkgray, bg = colors.visual, gui = "bold" },
        b = { fg = colors.gray, bg = colors.outerbg },
        c = { fg = colors.gray, bg = colors.innerbg },
    },
    replace = {
        a = { fg = colors.darkgray, bg = colors.replace, gui = "bold" },
        b = { fg = colors.gray, bg = colors.outerbg },
        c = { fg = colors.gray, bg = colors.innerbg },
    },
    normal = {
        a = { fg = colors.darkgray, bg = colors.normal, gui = "bold" },
        b = { fg = colors.gray, bg = colors.outerbg },
        c = { fg = colors.gray, bg = colors.innerbg },
    },
    insert = {
        a = { fg = colors.darkgray, bg = colors.insert, gui = "bold" },
        b = { fg = colors.gray, bg = colors.outerbg },
        c = { fg = colors.gray, bg = colors.innerbg },
    },
    command = {
        a = { fg = colors.darkgray, bg = colors.command, gui = "bold" },
        b = { fg = colors.gray, bg = colors.outerbg },
        c = { fg = colors.gray, bg = colors.innerbg },
    },
}

plugin.setup {
  options = {
    icons_enabled = true,
    theme = custom_theme,

    component_separators = { '' },
    section_separators = { left = ''},
    disabled_filetypes = {
      'NvimTree',
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = false,
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
    }
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {'filename'},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {}
}


