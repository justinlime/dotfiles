-- safe imports
local status, cmp = pcall(require, "cmp")
if not status then
    print("cmp not installed")
    return
end
local status, luasnip = pcall(require, "luasnip")
if not status then
    print("luasnip not installed")
    return
end
local status, cmp_capabilities = pcall(require, "cmp_nvim_lsp")
if not status then
    print("cmp_nvim_lsp not installed")
    return
end
-- local status, null_ls = pcall(require, "null-ls")
-- if not status then
--     print("null-ls not installed")
--     return
-- end
local status, lspconfig = pcall(require, "lspconfig")
if not status then
    print("lspconfig not installed")
    return
end

require("luasnip.loaders.from_vscode").lazy_load() -- For friendly snippets, boilerplate JS, HTML, etc

-- for consistency
local diagnostic = vim.diagnostic
local lsp = vim.lsp
local keymap = vim.keymap
local api = vim.api

diagnostic.config({
    virtual_text = true,
    severity_sort = true,
    underline = true,
})

local augroup = api.nvim_create_augroup("LspFormatting", {})

local on_attach = function(client, bufnr)
    -- format on save
    if client.supports_method("textDocument/formatting") then
        -- api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
        -- api.nvim_create_autocmd("BufWritePre", {
        --     group = augroup,
        --     buffer = bufnr,
        --     callback = function()
        --         lsp.buf.format({ async = false })
        --     end,
        -- })
    end

    local map_opts = {
        buffer = true,
        silent = true,
    }

    local float_window_width = 45

    keymap.set("n", "<space>s", function()
        lsp.buf.hover()
    end, map_opts)

    lsp.handlers["textDocument/hover"] = lsp.with(vim.lsp.handlers.hover, {
        border = "rounded",
        width = float_window_width,
    })

    keymap.set("n", "<space>e", function()
        diagnostic.open_float(0, {
            source = "always",
            scope = "line",
            header = false,
            width = float_window_width,
            border = "rounded",
        })
    end, map_opts)
end

local capabilities = cmp_capabilities.default_capabilities()
lspconfig.jedi_language_server.setup({
    --Python
    on_attach = on_attach,
    capabilities = capabilities,
})
lspconfig.tsserver.setup({
    -- Javascript and Typescript
    on_attach = on_attach,
    capabilities = capabilities,
})
lspconfig.html.setup({
    on_attach = on_attach,
    capabilities = capabilities,
})
lspconfig.hls.setup({
    on_attach = on_attach,
    capabilities = capabilities,
})
lspconfig.rust_analyzer.setup({
    on_attach = on_attach,
    capabilities = capabilities,
})
lspconfig.cssls.setup({
    on_attach = on_attach,
    capabilities = capabilities,
})
lspconfig.lua_ls.setup({
    on_attach = on_attach,
    capabilities = capabilities,
})
lspconfig.bashls.setup({
    on_attach = on_attach,
    capabilities = capabilities,
})
lspconfig.clangd.setup({
    on_attach = on_attach,
    capabilities = capabilities,
})
lspconfig.dockerls.setup({
    on_attach = on_attach,
    capabilities = capabilities,
})
lspconfig.yamlls.setup({
    on_attach = on_attach,
    capabilities = capabilities,
})
lspconfig.zls.setup({
    on_attach = on_attach,
    capabilities = capabilities,
})
lspconfig.grammarly.setup({
    on_attach = on_attach,
    capabilities = capabilities,
})
lspconfig.gopls.setup({
    on_attach = on_attach,
    capabilities = capabilities,
})
-- lspconfig.nil_ls.setup({
--     on_attach = on_attach,
--     capabilities = capabilities,
-- })
lspconfig.nixd.setup({
    on_attach = on_attach,
    capabilities = capabilities,
})
lspconfig.jsonls.setup({
    on_attach = on_attach,
    capabilities = capabilities,
})

local has_root = function(root_files)
    return function(utils)
        return utils.root_has_file(root_files)
    end
end
local js_conf = function(root_files)
    return {
        only_local = "node_modules/.bin",
        condition = has_root(root_files),
    }
end

-- null_ls.setup({
--     on_attach = on_attach,
--     capabilities = capabilities,
--     sources = {
--         -- format
--         null_ls.builtins.formatting.stylua,
--         null_ls.builtins.formatting.prettierd.with({
--             extra_filetypes = { "svelte", "toml" },
--             js_conf({
--                 ".prettierrc",
--                 ".prettierrc.cjs",
--                 ".prettierrc.js",
--                 ".prettierrc.json",
--                 "prettier.config.js",
--             }),
--         }),
--         null_ls.builtins.formatting.eslint_d.with(js_conf({
--             ".eslintrc",
--             ".eslintrc.cjs",
--             ".eslintrc.js",
--             ".eslintrc.json",
--         })),
--
--         -- diagnostics
--         null_ls.builtins.diagnostics.eslint_d.with(js_conf({
--             ".eslintrc",
--             ".eslintrc.cjs",
--             ".eslintrc.js",
--             ".eslintrc.json",
--         })),
--
--         -- code actions
--         null_ls.builtins.code_actions.gitsigns,
--         null_ls.builtins.code_actions.eslint_d.with(js_conf({
--             ".eslintrc",
--             ".eslintrc.cjs",
--             ".eslintrc.js",
--             ".eslintrc.json",
--         })),
--     },
-- })
local kind_icons = {
    Text = "",
    Method = "",
    Function = "",
    Constructor = "",
    Field = "ﰠ",
    Variable = "",
    Class = "ﴯ",
    Interface = "",
    Module = "",
    Property = "ﰠ",
    Unit = "塞",
    Value = "",
    Enum = "",
    Keyword = "",
    Snippet = "",
    Color = "",
    File = "",
    Reference = "",
    Folder = "",
    EnumMember = "",
    Constant = "",
    Struct = "פּ",
    Event = "",
    Operator = "",
    TypeParameter = "",
    Copilot = "",
}
cmp.setup({
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    window = {
        completion = cmp.config.window.bordered({
            scrollbar = false,
            max_width = 1,
            max_height = 1,
        }),
        documentation = cmp.config.window.bordered()
    },
    mapping = {
        ['<C-k>'] = cmp.mapping.scroll_docs(-4),
        ['<C-j>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            else
                fallback()
            end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            else
                fallback()
            end
        end, { "i", "s" }),
        ['<CR>'] = cmp.mapping({
            i = function(fallback)
                if cmp.visible() then
                    cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true })
                else
                    fallback()
                end
            end,
        }),
    },
    formatting = {
        fields = { "kind", "abbr", "menu" },
        format = function(_, item)
            local label_width = 45
            local label = item.abbr
            local truncated_label = vim.fn.strcharpart(label, 0, label_width)

            if truncated_label ~= label then
                item.abbr = truncated_label .. "…"
            elseif string.len(label) < label_width then
                local padding = string.rep(" ", label_width - string.len(label))
                item.abbr = label .. padding
            end

            item.menu = item.kind
            item.kind = kind_icons[item.kind]
            return item
        end,
    },
    sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "buffer" },
        { name = "path" },
        { name = "cmp_tabnine" },
        { name = "nvim_lua" },
        { name = "luasnip" },
    }),
})
