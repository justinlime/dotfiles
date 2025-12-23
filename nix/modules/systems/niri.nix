{ config, lib, pkgs, ... }:
let cfg = config.sysMods.niri; in 
{
  options.sysMods.niri = with lib.types; {
    enable = lib.mkEnableOption "Enable";
  };

  config = lib.mkIf cfg.enable {
    services.displayManager.ly.enable = true;
    services.upower.enable = true;
    programs.dankMaterialShell = {
      enable = true;
      systemd = {
        enable = true;             # Systemd service for auto-start
        restartIfChanged = true;   # Auto-restart dms.service when dms-shell changes
      };
      # Core features
      enableSystemMonitoring = true;     # System monitoring widgets (dgop)
      enableClipboard = true;            # Clipboard history manager
      enableVPN = true;                  # VPN management widget
      enableDynamicTheming = true;       # Wallpaper-based theming (matugen)
      enableAudioWavelength = true;      # Audio visualizer (cava)
      enableCalendarEvents = true;       # Calendar integration (khal)
    };
    programs.niri.enable = true;
    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";  
      XDG_CURRENT_DESKTOP = "sway";
    };
    programs.obs-studio.enable = true;
    services.pipewire.enable = true;
    xdg.portal = {
      enable = true;
      extraPortals = [
        pkgs.xdg-desktop-portal
        pkgs.xdg-desktop-portal-gtk
        pkgs.xdg-desktop-portal-wlr
      ];
    };
  };
}
