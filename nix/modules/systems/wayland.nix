{ lib, pkgs, config, ... }:
let cfg = config.sysMods.wayland; in 
{
  options.sysMods.wayland = with lib.types; {
    enable = lib.mkEnableOption "Enable";
  };
  config = lib.mkIf cfg.enable {
    # Services needed for my desktop environment
    security.rtkit.enable = true; 
    services = {
      xserver = {
        enable = true; 
        displayManager.gdm.enable = true;
      };
      gnome.gnome-keyring.enable = true;
      gvfs = {
        enable = true;
        package = lib.mkForce pkgs.gnome.gvfs;
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
  };
}

