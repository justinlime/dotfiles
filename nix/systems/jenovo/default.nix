{ flake_path, ... }:
{
  imports = [ 
    ./hardware-configuration.nix 
    # ./services
    ../base/configuration.nix
    ../base/gaming.nix
    ../base/wayland.nix
    ../base/networking.nix
    ../base/virtulization.nix
    ../base/usb.nix
    ../base/avahi.nix
    ../base/docker.nix
  ];
  services.logind.extraConfig = ''
    HandlePowerKey=ignore
  '';
  programs = {
    light.enable = true;
  };
  networking.hostName = "jenovo";
  hardware.ledger.enable = true;
  services = {
    tlp.enable = true;
  };
}
