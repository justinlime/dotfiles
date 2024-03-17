# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot = { 
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
    initrd.kernelModules = [ 
      "amdgpu" 
    ];
    # New kernels crash my desktop for some reason, still have to debug that
    kernelPackages = pkgs.linuxPackages_6_1;
    kernelModules = [ "kvm-amd" ];
  };
  fileSystems = {
    "/" = { 
      device = "/dev/disk/by-uuid/9c3f89cf-f24b-45a1-b256-618896c1d1d0";
      fsType = "btrfs";
      options = [ "compress=zstd:1" "noatime" "subvol=root" ];
    };
    "/boot" = { 
      device = "/dev/disk/by-uuid/FC74-CDE4";
      fsType = "vfat";
    };
    "/home" = { 
      device = "/dev/disk/by-uuid/9c3f89cf-f24b-45a1-b256-618896c1d1d0";
      fsType = "btrfs";
      options = [ "compress=zstd:1" "noatime" "subvol=home" ];
    };
    "/nix" = { 
      device = "/dev/disk/by-uuid/9c3f89cf-f24b-45a1-b256-618896c1d1d0";
      fsType = "btrfs";
      options = [ "compress=zstd:1" "noatime" "subvol=nix" ];
    };
    "/drives/nvme1" = {
      device = "/dev/disk/by-label/nvme1";
      fsType = "btrfs";
      options = [ "compress-force=zstd:1" "noatime" "subvol=nvme1" ];
    };
  };
  swapDevices = [ ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlo1.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware = {
    cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };
  };
}
