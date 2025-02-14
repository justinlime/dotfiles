{ config, lib, ... }:
let cfg = config.homeMods.syncthing; in 
{
  options.homeMods.syncthing = {
   enable = lib.mkEnableOption "Enable"; 
  };
  config = lib.mkIf cfg.enable {
    services.syncthing = {
      enable = true; 
    };
  };
}
