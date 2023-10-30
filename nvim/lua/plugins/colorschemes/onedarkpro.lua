local status, plugin = pcall(require,'onedarkpro')
if not status then
    print('Plugin Error: ', plugin)
    return
end
plugin.setup({})
