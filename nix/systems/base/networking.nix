{ ... }:
{
  # Enable the firewall
  networking = {
    firewall = {
      allowedTCPPorts = [ 3000 ];
      allowedUDPPorts = [ 3000 ];
      enable = true;
      checkReversePath = false; 
    };
  };
}
 
