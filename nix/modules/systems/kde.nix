{ config, lib, pkgs, ... }:
let cfg = config.sysMods.kde; in 
{
  options.sysMods.kde = with lib.types; {
    enable = lib.mkEnableOption "Enable";
  };
  config = lib.mkIf cfg.enable {
    xdg.portal = {
      enable = true;
    };
    services = {
      # xserver.enable = true;
      displayManager.sddm = {
        enable = true;   
        # wayland.enable = true;
      };
      pipewire = {
        enable = true;
        audio.enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        wireplumber.enable = true;
      };
      desktopManager = {
        plasma6.enable = true;  
      };
    };
  };
}
