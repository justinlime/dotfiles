{ pkgs, ... }:
{
  imports = [ 
    ./hardware-configuration.nix 
  ];
  sysMods = {
    system = rec {
      username = "justinlime";  
      flakeDirectory = "/home/${username}/dotfiles";
    }; 
    usbautomount.enable = true;
    virt.enable = true;
    kde.enable = true;
    gaming.enable = true;
    firewall = {
      enable = true;  
      BothPorts = [ 1313 6969 1317 ];
    };
  };
  networking.hostName = "jesktop";
  hardware.ledger.enable = true;
}
