{ pkgs,... }:
{
  homeMods = {
    home = rec {
      username = "justinlime";
      homeDirectory = "/home/${username}";
      flakeDirectory = "/home/${username}/dotfiles";
    }; 
    emacs.enable = true;
    nvim.enable = true; 
    zsh.enable = true;
    theme.enable = true; 
    tmux.enable = true;
    btop.enable = true;
    foot.enable = true;
    ranger.enable = true; 
  };
  home.packages = with pkgs; [
    brave 
    remmina
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
