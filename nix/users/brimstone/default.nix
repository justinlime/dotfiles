{ profile, inputs, username, flake_path, pkgs, pkgsStable, ... }:
{
  # Brimstone is my main everyday home configuration, including a number
  # of tools and services i use on a daily basis
  jfg = {
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
    hyprland = {
      enable = true;
      monitors = [ "eDP-1,2880x1800@120,0x0,1.6" ];
    }; 
    hyprlock.enable = true;
    hypridle.enable = true;
    waybar.enable = true;
    wofi.enable = true;
    foot.enable = true;
    syncthing.enable = true;
    mpd.enable = true;
    theme.enable = true;
    direnv.enable = true;
  };
  home.packages = with pkgs; [
    brave 
    firefox
    gimp
    mpv
    neofetch
    obs-studio
    prismlauncher
    speedtest-cli
    telegram-desktop
    vial
    imagemagick
    jellyfin-media-player
    element-desktop
    scrcpy
  ];
}
