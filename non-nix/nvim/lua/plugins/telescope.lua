local status, plugin = pcall(require,'telescope')
if not status then
    print('Error with plugin: ', plugin)
    return
end
plugin.setup{
    defaults = {
        -- Default configuration for telescope goes here:
        -- config_key = value,
        layout_strategy = "vertical",
        layout_config = {
          height = vim.o.lines, -- maximally available lines
          width = vim.o.columns, -- maximally available columns
          prompt_position = "top",
          preview_height = 0.6, -- 60% of available lines
        },
        border = true;
        mappings = {
            i = {
                -- map actions.which_key to <C-h> (default: <C-/>)
                -- actions.which_key shows the mappings for your picker,
                -- e.g. git_{create, delete, ...}_branch for the git_branches picker
                ["<C-h>"] = "which_key"
            }
        }
    },
    pickers = {
        find_files = {
            file_ignore_patterns = { ".git/", ".undo/",".backup/"},
        },
        live_grep = {
        },
        -- Default configuration for builtin pickers goes here:
        -- picker_name = {
            --   picker_config_key = value,
            --   ...
            -- }
            -- Now the picker_config_key will be applied every time you call this
            -- builtin picker
        },
        extensions = {
            -- Your extension configuration goes here:
            -- extension_name = {
                --   extension_config_key = value,
                -- }
                -- please take a look at the readme of the extension you want to configure
            }
}
