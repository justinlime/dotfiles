{ pkgs, flake_path, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../base/configuration.nix
    ../base/gaming.nix
    ../base/wayland.nix
    ../base/networking.nix
    ../base/virtulization.nix
    ../base/usb.nix
  ];
  hardware.ledger.enable = true;
  hardware.keyboard.qmk.enable = true;
  networking.hostName = "jesktop";
}
