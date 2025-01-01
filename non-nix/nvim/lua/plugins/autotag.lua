local status, plugin = pcall(require,'nvim-ts-autotag')
if not status then
    print('Error with plugin: ', plugin)
    return
end
plugin.setup({
    autotag = {
        enable = true,
    }
})

