{ profile, pkgs, username, inputs, flake_path, ... }:
{
  # Janus is a home build for tools id be using typically on
  # a headless server of some kind
  jfg = {
    home = {
      username = "justinlime";
      homeDirectory = "/home/justinlime";
      flakeDirectory = "/home/justinlime/dotfiles";
    };
    emacs.enable = true;
    nvim.enable = true; 
    zsh.enable = true;
    tmux.enable = true;
    btop.enable = true;
  };
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
