{ pkgs, flake_path, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../base/configuration.nix
    ../base/gaming.nix
    ../base/wayland.nix
    ../base/networking.nix
    ../base/virtulization.nix
  ];
  hardware.ledger.enable = true;
  networking.hostName = "jesktop";
}
