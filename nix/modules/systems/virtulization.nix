{ config, lib, pkgs, ... }:
let cfg = config.jfg.virt; in 
{
  options.jfg.virt = with lib.types; {
    enable = lib.mkEnableOption "Enable"; 
  };
  config = lib.mkIf cfg.enable {
    # Enable virtualization with qemu and virt-manager and add the admin user to the necessary groups
    users.users.${config.jfg.system.username}.extraGroups = [ "kvm" "input" "libvirtd" ];
    environment.systemPackages = with pkgs; [
      virt-manager
      virt-viewer
      win-spice
      win-virtio
      spice
      spice-gtk
      spice-protocol
    ];
    services.spice-vdagentd.enable = true;
    virtualisation = {
      spiceUSBRedirection.enable = true;
      libvirtd = {
        enable = true;
        allowedBridges = ["wlo1"];
        qemu = {
          swtpm.enable = true;
          ovmf.enable = true;
          ovmf.packages = [ pkgs.OVMFFull.fd ];
        };
      };
    };
  };
}
