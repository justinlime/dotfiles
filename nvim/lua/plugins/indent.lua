local status, plugin = pcall(require,'indent_blankline')
if not status then
    print('Error with plugin: ', plugin)
    return
end
plugin.setup{
    show_current_context = true,
    show_current_context_start = true,
}
vim.g.indent_blankline_filetype_exclude = {'dashboard'}


