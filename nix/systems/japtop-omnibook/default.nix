{ flake_path, ... }:
{
  imports = [ 
    ./hardware-configuration.nix 
    ../base/configuration.nix
    ../base/gaming.nix
    ../base/wayland.nix
    ../base/networking.nix
    ../base/virtulization.nix
    ../base/usb.nix
    ../base/avahi.nix
    ../base/docker.nix
  ];
  programs = {
    light.enable = true;
  };
  networking.hostName = "japtop";
  hardware.ledger.enable = true;
  services = {
    tlp.enable = true;
  };
}
