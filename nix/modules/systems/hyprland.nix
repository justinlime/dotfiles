{ config, lib, pkgs, ... }:
let cfg = config.sysMods.hyprland; in 
{
  options.sysMods.hyprland = with lib.types; {
    enable = lib.mkEnableOption "Enable";
  };

  config = lib.mkIf cfg.enable {
<<<<<<< Updated upstream
    services.displayManager.ly.enable = true;
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
    programs.hyprland.enable = true;
=======
    programs = {
      obs-studio.enable = true;
      hyprland = {
        enable = true;  
        xwayland.enable = true;
      };
    };
>>>>>>> Stashed changes
    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";  
      MOZ_ENABLE_WAYLAND = "1";
      XDG_SESSION_TYPE = "wayland";
      XDG_SESSION_DESKTOP = "Hyprland";
      XDG_CURRENT_DESKTOP = "Hyprland";
    #   HYPR_PLUGIN_DIR = pkgs.symlinkJoin {
    #     name = "hyprland-plugins";
    #     paths = with pkgs.hyprlandPlugins; [
    #     ];
    #   };
    };
    security.rtkit.enable = true;
    services = {
      xserver.enable = true;
      pipewire = {
        enable = true;
        wireplumber.enable = true;
      };
    };
    xdg.portal = {
      enable = true;
      xdgOpenUsePortal = true;
      extraPortals = [
        pkgs.xdg-desktop-portal-gtk
        pkgs.xdg-desktop-portal-hyprland
      ];
    };
  };
}
