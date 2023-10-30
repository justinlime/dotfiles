local status, plugin = pcall(require, 'dashboard')
if not status then
    print('Error with plugin: ', plugin)
    return
end

plugin.setup({
    theme = 'doom',
    config = {
        header = randomsplash(),
        center = {
            {
                icon = ' ',
                icon_hl = '@variable',
                desc = 'Find File',
                desc_hl = 'String',
                key = 'f',
                keymap = 'SPC ff',
                key_hl = 'Number',
                action = 'Telescope find_files'
            },
            {
                icon = ' ',
                icon_hl = '@variable',
                desc = 'File Browser',
                desc_hl = 'String',
                key = 'd',
                keymap = 'SPC dt',
                key_hl = 'Number',
                action = 'NvimTreeToggle'
            },
            {
                icon = '󰚰 ',
                icon_hl = '@variable',
                desc = 'Update',
                desc_hl = 'String',
                key = 'u',
                keymap = ':Lazy update',
                key_hl = 'Number',
                action = 'Lazy update'
            },
            {
                icon = ' ',
                icon_hl = '@variable',
                desc = 'Transparency Toggle',
                desc_hl = 'String',
                key = 't',
                keymap = 'SPC tt',
                key_hl = 'Number',
                action = 'TransparentToggle'
            },
            {
                icon = '󱓥 ',
                icon_hl = '@variable',
                desc = 'Edit Neovim',
                desc_hl = 'String',
                key = 'e',
                keymap = 'SPC en',
                key_hl = 'Number',
                action = 'lua edit_nvim()' -- Declared in functions.lua
            },

        },
        footer = {
            randomquote()
        }
    }
})
