{ lib, pkgs, ... }:
{
    # List services that you want to enable:
    hardware.ledger.enable = true;
    services = {
        xserver.enable = true;
        xserver.displayManager.gdm.enable = true;
        gnome.gnome-keyring.enable = true;
        gvfs = {
            enable = true;
            package = lib.mkForce pkgs.gnome3.gvfs;
        };
        pipewire = {
            enable = true;
            alsa.enable = true;
            alsa.support32Bit = true;
            pulse.enable = true;
        };
        udev.packages = with pkgs; [
          via
        ];
    };
    xdg.portal = {
        enable = true;
        # wlr.enable = true;
        extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
    };
    security.pam.services.swaylock = { #Swaylock fix for wrong password
        text = ''
            auth include login
            '';
    };
}

