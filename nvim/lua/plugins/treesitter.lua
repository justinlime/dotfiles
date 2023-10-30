local status, plugin = pcall(require,'nvim-treesitter.configs')
if not status then
   print('Plugin Error: ', plugin)
   return
end
plugin.setup {
  -- A list of parser names, or "all" (the four listed parsers should always be installed)
  ensure_installed = { 
      "c", 
      "lua", 
      "vim", 
      "python", 
      "html", 
      "htmldjango",
      "go",
      "javascript",
      "typescript",
      "toml",
      "css",
      "gitignore",
      "gitcommit",
      "git_rebase",
      "gitattributes",
      "cpp",
      "dockerfile",
      "c_sharp",
      "jq",
      "jsonnet",
      "kotlin",
      "rust",
      "ruby",
      "solidity",
      "sql",
      "yaml",
      "nix",
  },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  auto_install = true,

  -- List of parsers to ignore installing (for "all")
  --ignore_install = { "javascript" },

  ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
  -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

  highlight = {
    -- `false` will disable the whole extension
    enable = true,
    use_languagetree = true,
    disable = {"css", "html" },
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,

  },
}
