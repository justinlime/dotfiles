local status, plugin = pcall(require,'colorizer')
if not status then
    print('Error with plugin: ', plugin)
    return
end
plugin.setup()

