{ config, lib, pkgs, username, inputs, ... }:
{
  # Enable virtualization with qemu and virt-manager and add the admin user to the necessary groups
  users.users.${username}.extraGroups = [ "kvm" "input" "libvirtd" ];
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
}
