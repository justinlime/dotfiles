{ inputs , pkgs, username, ... }:
{
  services.syncthing = {
    enable = true; 
  };
  home.packages = with pkgs; [
    emacs29-pgtk
    tree-sitter
    gcc #needed to compile treesitter langs in emacs
		lua-language-server #Lua
    elixir-ls
    nixd 
    gopls #Golang
    rust-analyzer #Rust
    zls #Zig
    clang-tools #C
    python311Packages.jedi-language-server #Python
    # haskellPackages.hls # Haskell
    nodePackages_latest.vscode-langservers-extracted #HTML,CSS, JSON
    nodePackages_latest.grammarly-languageserver #Markdown
    nodePackages_latest.typescript-language-server #Javascript and Typescript
    nodePackages_latest.bash-language-server #Bash
    nodePackages_latest.dockerfile-language-server-nodejs #Dockerfiles
    nodePackages_latest.yaml-language-server #Yaml
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
