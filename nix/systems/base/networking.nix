{ ... }:
{
  # Enable the firewall
  networking = {
    firewall = {
      enable = true;
      checkReversePath = false; 
    };
  };
}
 
