{ config, lib, ... }:
let cfg = config.jfg.syncthing; in 
{
  options.jfg.syncthing = {
   enable = lib.mkEnableOption "Enable"; 
  };
  config = lib.mkIf cfg.enable {
    services.syncthing = {
      enable = true; 
    };
  };
}
