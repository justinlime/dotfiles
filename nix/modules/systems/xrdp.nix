{ config, lib, pkgs, ... }:
let cfg = config.sysMods.xrdp; in 
{
  options.sysMods.xrdp = with lib.types; {
    enable = lib.mkEnableOption "Enable";
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ firefox ];
    services = {
      displayManager.defaultSession = "xfce";
      xserver = {
        enable = true;
        desktopManager = {
          xterm.enable = true;
          xfce.enable = true;
        };
      };
      xrdp = {
       enable = true;
       openFirewall = true;
       defaultWindowManager = "${pkgs.xfce.xfce4-session}/bin/xfce4-session";
      };
    };
  };
}
