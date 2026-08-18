{ profile, inputs, username, flake_path, pkgs, pkgsStable, ... }:
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
    tmux.enable = true;
    btop.enable = true;
    rofi.enable = true;
    ghostty.enable = true;
    syncthing.enable = true;
    mpd.enable = true;
    theme.enable = true;
    direnv.enable = true;
    niri.enable = true;
  };
  home.packages = with pkgs; [
    brave 
    firefox
    gimp
    mpv
    obs-studio
    prismlauncher
    speedtest-cli
    telegram-desktop
    vial
    imagemagick
    element-desktop
    scrcpy
  ];
}
