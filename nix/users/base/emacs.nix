{ inputs , pkgs, username, ... }:
{
  home.packages = with pkgs; [
    # Runtime
    emacs29-pgtk
    tree-sitter
    gcc 
    imagemagick
    # Language Servers
		lua-language-server 
    elixir-ls
    nixd 
    go 
    gopls 
    rust-analyzer
    zls #Zig
    clang-tools #C
    python311Packages.jedi-language-server #Python
    java-language-server
    nodePackages_latest.vscode-langservers-extracted #HTML,CSS, JSON
    nodePackages_latest.typescript-language-server #Javascript and Typescript
    nodePackages_latest.bash-language-server
    nodePackages_latest.dockerfile-language-server-nodejs #Dockerfiles
    nodePackages_latest.yaml-language-server
    # Fonts
    roboto
    (nerdfonts.override { fonts = [ "RobotoMono" ]; })
  ];
  xdg.configFile = {
    "emacs/early-init.el".source = "${inputs.self}/emacs/early-init.el";
    "emacs/init.el".source = "${inputs.self}/emacs/init.el";
    "emacs/config.org".source = "${inputs.self}/emacs/config.org";
    "emacs/icons/".source = "${inputs.self}/emacs/icons/";
  };
}
