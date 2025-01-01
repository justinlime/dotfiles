-- OR setup with some options
local status, plugin = pcall(require, 'nvim-tree')
if not status then
    print('Plugin Error: ', plugin)
    return
end


--Automatically opens nvim tree on startup if running only "nvim"
-- local function open_nvim_tree(data)
--
--   -- buffer is a [No Name]
--   local no_name = data.file == "" and vim.bo[data.buf].buftype == ""
--
--   -- buffer is a directory
--   local directory = vim.fn.isdirectory(data.file) == 1
--
--   if not no_name and not directory then
--     return
--   end
--
--   -- change to the directory
--   if directory then
--     vim.cmd.cd(data.file)
--   end
--
--   -- open the tree
--   require("nvim-tree.api").tree.open()
-- end
-- vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })
local unmap = vim.keymap.del
local map = vim.keymap.set

local function on_attach(bufnr)
    local api = require('nvim-tree.api')

    local function opts(desc)
        return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
    end


    -- Default mappings. Feel free to modify or remove as you wish.
    --
    -- BEGIN_DEFAULT_ON_ATTACH
    map('n', '<Tab>', api.tree.change_root_to_node, opts('CD'))
    map('n', '<C-e>', api.node.open.replace_tree_buffer, opts('Open: In Place'))
    map('n', '<C-k>', api.node.show_info_popup, opts('Info'))
    map('n', '<C-r>', api.fs.rename_sub, opts('Rename: Omit Filename'))
    map('n', '<C-t>', api.node.open.tab, opts('Open: New Tab'))
    map('n', '<C-v>', api.node.open.vertical, opts('Open: Vertical Split'))
    map('n', '<C-x>', api.node.open.horizontal, opts('Open: Horizontal Split'))
    map('n', '<BS>', api.node.navigate.parent_close, opts('Close Directory'))
    map('n', '<CR>', api.node.open.edit, opts('Open'))
    map('n', 'pp', api.node.open.preview, opts('Open Preview'))
    map('n', '>', api.node.navigate.sibling.next, opts('Next Sibling'))
    map('n', '<', api.node.navigate.sibling.prev, opts('Previous Sibling'))
    map('n', '.', api.node.run.cmd, opts('Run Command'))
    map('n', 'u', api.tree.change_root_to_parent, opts('Up'))
    map('n', 'a', api.fs.create, opts('Create'))
    map('n', 'bmv', api.marks.bulk.move, opts('Move Bookmarked'))
    map('n', 'B', api.tree.toggle_no_buffer_filter, opts('Toggle No Buffer'))
    map('n', 'c', api.fs.copy.node, opts('Copy'))
    map('n', 'C', api.tree.toggle_git_clean_filter, opts('Toggle Git Clean'))
    map('n', '[c', api.node.navigate.git.prev, opts('Prev Git'))
    map('n', ']c', api.node.navigate.git.next, opts('Next Git'))
    map('n', 'd', api.fs.remove, opts('unmapete'))
    map('n', 'D', api.fs.trash, opts('Trash'))
    map('n', 'E', api.tree.expand_all, opts('Expand All'))
    map('n', 'e', api.fs.rename_basename, opts('Rename: Basename'))
    map('n', ']e', api.node.navigate.diagnostics.next, opts('Next Diagnostic'))
    map('n', '[e', api.node.navigate.diagnostics.prev, opts('Prev Diagnostic'))
    map('n', 'F', api.live_filter.clear, opts('Clean Filter'))
    map('n', 'f', api.live_filter.start, opts('Filter'))
    map('n', 'g?', api.tree.toggle_help, opts('Help'))
    map('n', 'gy', api.fs.copy.absolute_path, opts('Copy Absolute Path'))
    map('n', 'H', api.tree.toggle_hidden_filter, opts('Toggle Dotfiles'))
    map('n', 'I', api.tree.toggle_gitignore_filter, opts('Toggle Git Ignore'))
    map('n', 'J', api.node.navigate.sibling.last, opts('Last Sibling'))
    map('n', 'K', api.node.navigate.sibling.first, opts('First Sibling'))
    map('n', 'm', api.marks.toggle, opts('Toggle Bookmark'))
    map('n', 'o', api.node.open.edit, opts('Open'))
    map('n', 'O', api.node.open.no_window_picker, opts('Open: No Window Picker'))
    map('n', 'p', api.fs.paste, opts('Paste'))
    map('n', 'P', api.node.navigate.parent, opts('Parent Directory'))
    map('n', 'q', api.tree.close, opts('Close'))
    map('n', 'r', api.fs.rename, opts('Rename'))
    map('n', 'R', api.tree.reload, opts('Refresh'))
    map('n', 's', api.node.run.system, opts('Run System'))
    map('n', 'S', api.tree.search_node, opts('Search'))
    map('n', 'U', api.tree.toggle_custom_filter, opts('Toggle Hidden'))
    map('n', 'W', api.tree.collapse_all, opts('Collapse'))
    map('n', 'x', api.fs.cut, opts('Cut'))
    map('n', 'y', api.fs.copy.filename, opts('Copy Name'))
    map('n', 'Y', api.fs.copy.relative_path, opts('Copy Relative Path'))
    map('n', '<2-LeftMouse>', api.node.open.edit, opts('Open'))
    map('n', '<2-RightMouse>', api.tree.change_root_to_node, opts('CD'))
    -- END_DEFAULT_ON_ATTACH


    -- Mappings removed via:
    --   remove_keymaps
    --   OR
    --   view.mappings.list..action = ""
    --
    -- The dummy set before unmap is done for safety, in case a default mapping does not exist.
    --
    -- You might tidy things by removing these along with their default mapping.
    map('n', 'O', '', { buffer = bufnr })
    unmap('n', 'O', { buffer = bufnr })
    map('n', '<2-RightMouse>', '', { buffer = bufnr })
    unmap('n', '<2-RightMouse>', { buffer = bufnr })
    map('n', 'D', '', { buffer = bufnr })
    unmap('n', 'D', { buffer = bufnr })
    map('n', 'E', '', { buffer = bufnr })
    unmap('n', 'E', { buffer = bufnr })


    -- Mappings migrated from view.mappings.list
    --
    -- You will need to insert "your code goes here" for any mappings with a custom action_cb
    map('n', 'A', api.tree.expand_all, opts('Expand All'))
    map('n', '?', api.tree.toggle_help, opts('Help'))
    map('n', 'C', api.tree.change_root_to_node, opts('CD'))
    map('n', 'P', function()
        local node = api.tree.get_node_under_cursor()
        print(node.absolute_path)
    end, opts('Print Node Path'))

    map('n', 'Z', api.node.run.system, opts('Run System'))
end

vim.api.nvim_set_hl(0, "NvimTreeNormal", { bg = "none" })

plugin.setup({
    sort_by = "case_sensitive",
    on_attach = on_attach,
    view = {
        adaptive_size = true,
        preserve_window_proportions = true,
        width = {
            min = 20,
            max = 30,
        },
    },
    renderer = {
        group_empty = true,
    },
    filters = {
        dotfiles = false,
    },
})
