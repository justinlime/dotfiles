{ pkgs, username, hush, flake_path, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../base/configuration.nix
    ../base/gaming.nix
    ../base/wayland.nix
    ../base/networking.nix
    ../base/virtulization.nix
    ../base/usb.nix
    ../base/ssh.nix
  ];
  hardware.ledger.enable = true;
  hardware.keyboard.qmk.enable = true;
  networking.hostName = "jesktop";
  users.users.${username}.openssh.authorizedKeys.keys = [
    "${hush.ssh.public-keys.stinkserver}" 
  ];
}
