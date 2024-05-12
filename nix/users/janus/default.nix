{ profile, pkgs, username, inputs, flake_path, ... }:
{
  # Janus is a home build for tools id be using typically on
  # a headless server of some kind
  _module.args = { inherit profile inputs username; };
  imports = [ 
    ../base/configuration.nix
    ../base/editors/emacs.nix
    ../base/editors/neovim.nix
    ../base/programs/zsh.nix
    ../base/programs/tmux.nix
    ../base/programs/btop.nix
    ../base/programs/direnv.nix
  ];

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.11";
}
