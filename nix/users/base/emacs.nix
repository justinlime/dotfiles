{ inputs , pkgs, ... }:
{
  home.packages = with pkgs; [
    emacs29
    tree-sitter
		fzf
		lua-language-server #Lua
    # nil #Nix
    nixd 
    gopls #Golang
    rust-analyzer #Rust
    zls #Zig
    llvmPackages_15.clang-unwrapped #C, C++
    # python311Packages.jedi-language-server #Python
    # haskellPackages.hls # Haskell
    nodePackages_latest.vscode-langservers-extracted #HTML,CSS, JSON
    nodePackages_latest.grammarly-languageserver #Markdown
    nodePackages_latest.typescript-language-server #Javascript and Typescript
    nodePackages_latest.bash-language-server #Bash
    nodePackages_latest.dockerfile-language-server-nodejs #Dockerfiles
    nodePackages_latest.yaml-language-server #Yaml
  ];
  xdg.configFile = {
    "emacs/early-init.el".source = "${inputs.self}/emacs/early-init.el";
    "emacs/init.el".source = "${inputs.self}/emacs/init.el";
    "emacs/config.org".source = "${inputs.self}/emacs/config.org";
    "emacs/eyecropped.png".source = "${inputs.self}/emacs/eyecropped.png";
  };
}
