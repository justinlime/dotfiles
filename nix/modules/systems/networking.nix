{ config, lib, ... }:
let cfg = config.jfg.firewall; in 
{
  options.jfg.firewall = with lib.types; {
    enable = mkEnableOption "Enable";  
    TCPPorts = mkOption {
      type = listOf int;
    };
    UDPPorts = mkOption {
      type = listOf int;
    };
    BothPorts = mkOption {
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
 
