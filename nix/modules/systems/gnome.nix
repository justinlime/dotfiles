{ config, lib, pkgs, ... }:
let cfg = config.sysMods.gnome; in 
{
  options.sysMods.gnome = with lib.types; {
    enable = lib.mkEnableOption "Enable";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      gnomeExtensions.desktop-icons-ng-ding
      gnomeExtensions.dash-to-dock
      gnomeExtensions.just-perfection
      gnomeExtensions.arcmenu
      gnomeExtensions.tray-icons-reloaded
      gnome-remote-desktop
      gnome-tweaks
    ];
    xdg.portal = {
      enable = true;
    };
    services = {
      pipewire = {
        enable = true;
        audio.enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        wireplumber.enable = true;
      };
      gnome.games.enable = false;
      displayManager.gdm = {
        enable = true;
        autoSuspend = false;
      };
      desktopManager.gnome = {
        enable = true; 
        extraGSettingsOverrides = ''
          [org.gnome.mutter]
          experimental-features=['scale-monitor-framebuffer']  
        ''; 
      };
    };
  };
}
