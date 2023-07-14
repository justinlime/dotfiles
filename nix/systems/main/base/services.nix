{ lib, pkgs, ... }:
{
    # List services that you want to enable:
    hardware.ledger.enable = true;
    services = {
        xserver.enable = true;
        xserver.displayManager.gdm.enable = true;
        gnome.gnome-keyring.enable = true;
        spice-vdagentd.enable = true;
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
        # udev = {
        #     enable = true;
        #     packages = with pkgs; [
        #         ledger-udev-rules
        #     ];
        # };
    };
    virtualisation = {
        docker.enable = true;
        docker.storageDriver = "btrfs";
        spiceUSBRedirection.enable = true;
        libvirtd = {
            enable = true;
            qemu = {
                swtpm.enable = true;
                ovmf.enable = true;
                ovmf.packages = [ pkgs.OVMFFull.fd ];
            };
        };
    };
    security.pam.services.swaylock = { #Swaylock fix for wrong password
    text = ''
        auth include login
        '';
    };
}

