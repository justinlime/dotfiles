local status, plugin = pcall(require,'ibl')
if not status then
    print('Error with plugin: ', plugin)
    return
end
plugin.setup{}


