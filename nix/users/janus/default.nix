{ profile, pkgs, username, inputs, flake_path, ... }:
{
  # Janus is a home build for tools id be using typically on
  # a headless server of some kind
  _module.args = { inherit profile inputs username; };
  imports = [ 
    ../base/emacs.nix
    ../base/zsh.nix
    ../base/neovim.nix
    ../base/tmux.nix
    ../base/btop.nix
    ../base/configuration.nix
  ];

  home.packages = with pkgs; [
    inputs.maxfetch.packages.${pkgs.system}.default
  ];
  programs.direnv.enable = true;
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
