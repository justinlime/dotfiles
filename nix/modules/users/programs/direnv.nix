{ config, lib, ... }:
let cfg = config.jfg.direnv; in 
{
  options.jfg.direnv = {
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
