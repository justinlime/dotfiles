{ lib, pkgs, inputs, ... }:
{
  # Services needed for my desktop environment
  services = {
    xserver = {
      enable = true; 
      displayManager.gdm.enable = true;
    };
    gnome.gnome-keyring.enable = true;
    gvfs = {
      enable = true;
      package = lib.mkForce pkgs.gnome3.gvfs;
    };
    pipewire = {
      enable = true;
      audio.enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      wireplumber.enable = true;
    };
  };
  xdg.portal = {
    enable = true;
  };
  environment = {
    systemPackages = with pkgs; [
      pulseaudio 
      wl-clipboard
      libnotify
    ];
  };
  programs = {
    dconf.enable = true;
    direnv.enable = true;
    hyprland = {
      enable = true; 
      # package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    };
    thunar = {
      enable = true;
      plugins = with pkgs.xfce; [ 
        xfconf
        thunar-volman 
      ];
    };
  };
  security.pam.services.swaylock = { #Swaylock fix for wrong password
    text = ''
      auth include login
    '';
  };
}

