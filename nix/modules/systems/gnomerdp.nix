{ config, lib, pkgs, ... }:
let cfg = config.sysMods.gnomerdp; in 
{
  options.sysMods.gnomerdp = with lib.types; {
    enable = lib.mkEnableOption "Enable";
  };

  config = lib.mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [ 3389 ];
    environment.systemPackages = with pkgs; [
      gnomeExtensions.desktop-icons-ng-ding
      gnomeExtensions.dash-to-dock
      gnomeExtensions.just-perfection
      gnomeExtensions.arcmenu
      gnomeExtensions.tray-icons-reloaded
      gnome-remote-desktop
      freerdp
      firefox
      gnome-tweaks
    ];
    systemd.services.display-manager.restartIfChanged = false;
    services.displayManager.gdm = {
      enable = true;
      autoSuspend = false;
    };
    services.desktopManager.gnome = {
      enable = true; 
      extraGSettingsOverrides = ''
        [org.gnome.mutter]
        experimental-features=['scale-monitor-framebuffer']  
      ''; 
    };
    services.gnome.gnome-remote-desktop.enable = true;
    systemd.services.gnome-remote-desktop = {
      wantedBy = [ "graphical.target" ];
    };
    # These commands must be run imperatively below for the first setup.

    # sudo -u gnome-remote-desktop winpr-makecert -silent -rdp -path ~gnome-remote-desktop rdp-tls

    # sudo grdctl --system rdp set-tls-key /var/lib/gnome-remote-desktop/rdp-tls.key
    # sudo grdctl --system rdp set-tls-cert /var/lib/gnome-remote-desktop/rdp-tls.crt

    # sudo grdctl --system rdp set-credentials

    # sudo systemctl restart gnome-remote-desktop
  };
}
