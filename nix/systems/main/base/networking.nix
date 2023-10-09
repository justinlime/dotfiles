{ ... }:
{
    networking = {
        networkmanager.enable = true;
        firewall = {
            enable = true;
            checkReversePath = false; 
            allowedTCPPorts = [ 80 443 5900 ];
            allowedUDPPorts = [];
        };
    };
}
 
