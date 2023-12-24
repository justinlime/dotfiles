{ inputs , pkgs, pkgs_stable, ... }:
{
  home.packages = with pkgs; [
    neovim
    ripgrep
    #Language Servers

    lua-language-server #Lua
    # nil #Nix
    nixd 
    gopls #Golang
    rust-analyzer #Rust
    zls #Zig
    clang-tools #C
    #pkgs_stable.python311Packages.jedi-language-server #Python
    # haskellPackages.hls # Haskell
    nodePackages_latest.vscode-langservers-extracted #HTML,CSS, JSON
    nodePackages_latest.vscode-langservers-extracted #HTML,CSS, JSON
    nodePackages_latest.grammarly-languageserver #Markdown
    nodePackages_latest.typescript-language-server #Javascript and Typescript
    nodePackages_latest.bash-language-server #Bash
    nodePackages_latest.dockerfile-language-server-nodejs #Dockerfiles
    nodePackages_latest.yaml-language-server #Yaml
  ];
  xdg.configFile = {
    "nvim".source = "${inputs.self}/nvim";
  };
}
