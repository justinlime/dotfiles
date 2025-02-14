{ flake_path, ... }:
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
    wayland.enable = true;
    virt.enable = true;
    firewall = {
      enable = true;  
      BothPorts = [ 1313 6969 1317 ];
    };
  };
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
