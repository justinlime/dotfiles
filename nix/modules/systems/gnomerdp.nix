{ config, lib, pkgs, ... }:
let cfg = config.sysMods.gnomerdp; in 
{
  options.sysMods.gnomerdp = with lib.types; {
    enable = lib.mkEnableOption "Enable";
  };
  config = lib.mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [ 3389 ];
    environment.systemPackages = with pkgs; [
      gnome-remote-desktop
      freerdp
      firefox
      gnome-tweaks
    ];
    services.displayManager.gdm.enable = true;
    services.desktopManager.gnome = {
      enable = true; 
      extraGSettingsOverrides = ''
        [org.gnome.mutter]
        experimental-features=['scale-monitor-framebuffer']  
      ''; 
    };
    services.gnome.gnome-remote-desktop.enable = true;
    # These commands must be run imperatively below for the first setup.
    # Some may error out, dont worry.
    # This example will let you login as "name" "password"

    # sudo rm -rf ~gnome-remote-desktop/rdp-tls*
    # sudo -u gnome-remote-desktop winpr-makecert -silent -rdp -path ~gnome-remote-desktop rdp-tls

    # sudo grdctl --system rdp set-tls-key /var/lib/gnome-remote-desktop/rdp-tls.key
    # sudo grdctl --system rdp set-tls-cert /var/lib/gnome-remote-desktop/rdp-tls.crt

    # sudo systemctl daemon-reload
    # sudo grdctl --system rdp set-credentials "name" "password"

    # sudo systemctl restart gnome-remote-desktop.service
    # 
  };
}
