{ pkgs, ... }:
{
    home.packages = with pkgs; [
      neovim
      gcc

      #language servers:
      lua-language-server #Lua
      nil #Nix
      gopls #Golang
      rust-analyzer #Rust
      zls #Zig
      llvmPackages_15.clang-unwrapped #C, C++
      python311Packages.jedi-language-server #Python
      nodePackages_latest.vscode-langservers-extracted #HTML,CSS, JSON
      nodePackages_latest.grammarly-languageserver #Markdown
      nodePackages_latest.typescript-language-server #Javascript and Typescript
      nodePackages_latest.bash-language-server #Bash
      nodePackages_latest.dockerfile-language-server-nodejs #Dockerfiles
      nodePackages_latest.yaml-language-server #Yaml
    ];

    xdg.configFile = {
        "nvim".source = ../../../../.config/nvim;
    };
}
