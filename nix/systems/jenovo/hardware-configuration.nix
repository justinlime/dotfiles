# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];
  boot = {
    supportedFilesystems = [ "ntfs" ];
    kernelPackages = pkgs.linuxPackages_latest;
    kernelModules = [ "kvm-intel" ];
    ##### Get resume offset
    ## For non-btrfs:
    # sudo filefrag -v /swapfile | awk '{if($1=="0:"){print $4}}'
    ## For btrfs: 
    # sudo btrfs inspect-internal map-swapfile -r swap_file
    kernelParams = [ "resume_offset=22661317" ];
    resumeDevice = "/dev/disk/by-uuid/12f2eb04-67cd-460b-a6a5-d51efd59e19c";
    extraModulePackages = [ ];
    initrd = {
      availableKernelModules = [ "xhci_pci" "thunderbolt" "nvme" "usb_storage" "sd_mod" ];
      kernelModules = [ "dm-snapshot" ];
      luks.devices.root = {
        device = "/dev/disk/by-uuid/d1c78b64-7d41-4e25-a329-95a689b70a0c";
        preLVM = true;
      };
    };
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = true;
      timeout = 7;
    };
  };
  fileSystems."/" =
    { device = "/dev/disk/by-uuid/12f2eb04-67cd-460b-a6a5-d51efd59e19c";
    fsType = "btrfs";
    options = [ "subvol=root" "noatime" "compress=zstd:3" ];
    };

  fileSystems."/home" =
    { device = "/dev/disk/by-uuid/12f2eb04-67cd-460b-a6a5-d51efd59e19c";
    fsType = "btrfs";
    options = [ "subvol=home" "noatime" "compress=zstd:3" ];
    };

  fileSystems."/nix" =
    { device = "/dev/disk/by-uuid/12f2eb04-67cd-460b-a6a5-d51efd59e19c";
    fsType = "btrfs";
    options = [ "subvol=nix" "noatime" "compress=zstd:3" ];
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/8913-9ACA";
    fsType = "vfat";
    options = [ "fmask=0022" "dmask=0022" ];
    };

  fileSystems."/mnt/stinkserver" =
    { device = "10.0.0.200:/"; 
    fsType = "nfs";
    options = [ "nfsvers=4.2" "x-systemd.automount" "_netdev" "noauto" ];
    };

  swapDevices = [ {
    device = "/swapfile";
    size = 40 * 1024; # 40gb
  } ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp0s20f3.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
