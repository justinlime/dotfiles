{ lib, inputs, config, pkgs, pkgs_stable, ... }:
let cfg = config.homeMods.nvim; in 
{
  options.homeMods.nvim = {
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
      vscode-langservers-extracted #HTML,CSS, JSON
      typescript-language-server #Javascript and Typescript
      bash-language-server #Bash
      # nodePackages_latest.dockerfile-language-server-nodejs #Dockerfiles
      yaml-language-server #Yaml
    ];
    xdg.configFile = {
      "nvim".source = "${inputs.self}/non-nix/nvim";
    };
  };
}
