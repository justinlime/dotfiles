{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];
  boot = {
    supportedFilesystems = [ "ntfs" ];
    # For secure boot
    lanzaboote = {
     enable = true;  
     pkiBundle = "/var/lib/sbctl";
    };
    loader = {
      # Lanzaboote replaces systemdboot
      systemd-boot.enable = lib.mkForce false;
      efi.canTouchEfiVariables = true;
      timeout = 7;
    };
    initrd = {
      availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" ];
      kernelModules = [ ];
    };
    kernelPackages = pkgs.linuxPackages_cachyos;
    kernelModules = [ "kvm-amd" ];
    extraModulePackages = [ ];
  };
  
  fileSystems."/" =
    { device = "/dev/disk/by-label/NIXOS";
      fsType = "btrfs";
      options = [ "compress=zstd" "subvol=root" "noatime" ];
    };

  fileSystems."/home" =
    { device = "/dev/disk/by-label/NIXOS";
      fsType = "btrfs";
      options = [ "compress=zstd" "subvol=home" "noatime" ];
    };

  fileSystems."/nix" =
    { device = "/dev/disk/by-label/NIXOS";
      fsType = "btrfs";
      options = [ "compress=zstd" "subvol=nix" "noatime" ];
    };
  fileSystems."/drives/LINUX_GAMES/games" =
    { device = "/dev/disk/by-label/LINUX_GAMES";
      fsType = "btrfs";
      options = [ "compress-force=zstd:1" "subvol=games" "noatime" ];
    };
  fileSystems."/swap" =
    { device = "/dev/disk/by-label/NIXOS";
      fsType = "btrfs";
      options = [ "subvol=swap" "noatime" ];
    };
  fileSystems."/boot" =
    { device = "/dev/disk/by-label/NIXOS_BOOT";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };

  swapDevices = [ { device = "/swap/swapfile"; } ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.eno1.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp11s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  services = {
    xserver.videoDrivers = [ "nvidia" ];
    scx = {
      enable = true;  
      scheduler = "scx_lavd";
    };
  };
  hardware = {
    cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    nvidia = {
      package = config.boot.kernelPackages.nvidiaPackages.beta;
      modesetting.enable = true;
      powerManagement.enable = true;
      open = true;
      nvidiaSettings = true;
    };
    graphics = {
      enable = true;
      enable32Bit = true;
    };
  };
}
