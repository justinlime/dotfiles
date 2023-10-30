local status, plugin = pcall(require,'bufferline')
if not status then
    print('Error with plugin: ', plugin)
    return
end

plugin.setup{
    options = {
        close_command = "bdelete %d",
        right_mouse_command = "bdelete! %d", 
        left_mouse_command = "buffer %d",   
        middle_mouse_command = nil,        

        indicator = {
            style = 'none',
        },
        hover = {
            enabled = true,
            delay = 200,
            reveal = {'close'},
        },
        color_icons = true,
        numbers = "ordinal",
        offsets = {{filetype = "NvimTree", text = "File Explorer", padding = 0 }},
    },
}

