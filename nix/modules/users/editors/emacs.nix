{ lib, config, inputs, pkgs, username, ... }:
let cfg = config.homeMods.emacs; in 
{
  options.homeMods.emacs = {
   enable = lib.mkEnableOption "Enable"; 
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      # Runtime
      emacs30-pgtk
      tree-sitter
      gcc 
      imagemagick
      zoxide
      ispell
      # PDF viewing
      ghostscript
      # Language Servers
      lua-language-server 
      csharp-ls
      elixir-ls
      nixd 
      samba
      go 
      gopls 
      rust-analyzer
      zls #Zig
      clang-tools #C
      # python311Packages.jedi-language-server #Python
      java-language-server
      typescript
      pyright
      nodePackages_latest.vscode-langservers-extracted #HTML,CSS, JSON
      nodePackages_latest.bash-language-server
      # nodePackages_latest.dockerfile-language-server
      nodePackages_latest.yaml-language-server
      # Fonts
      roboto
      nerd-fonts.fira-code
    ];
    xdg.configFile = {
      "emacs/early-init.el".source = "${inputs.self}/non-nix/emacs/early-init.el";
      "emacs/init.el".source = "${inputs.self}/non-nix/emacs/init.el";
      "emacs/config.org".source = "${inputs.self}/non-nix/emacs/config.org";
      "emacs/icons/".source = "${inputs.self}/non-nix/emacs/icons/";
    };
  };
}
