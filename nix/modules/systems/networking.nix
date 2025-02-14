{ config, lib, ... }:
let cfg = config.sysMods.firewall; in 
{
  options.sysMods.firewall = with lib.types; {
    enable = lib.mkEnableOption "Enable";  
    TCPPorts = lib.mkOption {
      default = [ ];
      type = listOf int;
    };
    UDPPorts = lib.mkOption {
      default = [ ];
      type = listOf int;
    };
    BothPorts = lib.mkOption {
      default = [ ];
      type = listOf int;
    };
  };
  config = lib.mkIf cfg.enable {
    # Enable the firewall
    networking = {
      firewall = {
        enable = true;
        allowedTCPPorts = cfg.TCPPorts ++ cfg.BothPorts;
        allowedUDPPorts = cfg.UDPPorts ++ cfg.BothPorts;
        checkReversePath = false; 
      };
    };
  };
}
 
