{ config, lib, ... }:
let cfg = config.homeMods.direnv; in 
{
  options.homeMods.direnv = {
   enable = lib.mkEnableOption "Enable"; 
  };
  config = lib.mkIf cfg.enable {
    programs.direnv = {
      enable = true; 
      enableBashIntegration = true;
      enableZshIntegration = true;
    };
  };
}
