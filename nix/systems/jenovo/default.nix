{ pkgs, ... }:
{
  imports = [ 
    ./hardware-configuration.nix 
    ./suspend.nix
    ./wireguard.nix
  ];
  sysMods = {
    system = rec {
      username = "justinlime";  
      flakeDirectory = "/home/${username}/dotfiles";
    }; 
    usbautomount.enable = true;
    # gnomerdp.enable = true;
    # wayland.enable = true;
    # kde.enable = true;

    niri.enable = true;
    virt.enable = true;
    firewall = {
      enable = true;  
      BothPorts = [ 1313 6969 1317 ];
    };
  };
  services.logind.settings.Login=  {
    HandlePowerKey = "ignore";
    # HandleLidSwitch = "hibernate";
  };
  programs = {
    light.enable = true;
  };
  networking.hostName = "jenovo";
  hardware.ledger.enable = true;
  services = {
  };
}
