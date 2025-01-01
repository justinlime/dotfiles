{ lib, inputs, config, pkgs, pkgs_stable, ... }:
let cfg = config.jfg.nvim; in 
{
  options.jfg.nvim = {
    enable = lib.mkEnableOption "Enable";
  };
  config = lib.mkIf cfg.enable {
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
      nodePackages_latest.typescript-language-server #Javascript and Typescript
      nodePackages_latest.bash-language-server #Bash
      nodePackages_latest.dockerfile-language-server-nodejs #Dockerfiles
      nodePackages_latest.yaml-language-server #Yaml
    ];
    xdg.configFile = {
      "nvim".source = "${inputs.self}/non-nix/nvim";
    };
  };
}
