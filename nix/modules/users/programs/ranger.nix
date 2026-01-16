{ config, lib, pkgs, inputs, ...}:
let cfg = config.homeMods.ranger; in 
{
  options.homeMods.ranger = {
   enable = lib.mkEnableOption "Enable"; 
  };

  config = lib.mkIf cfg.enable {
    xdg.configFile = {
      "ranger/rc.conf".source = "${inputs.self}/non-nix/ranger/rc.conf";  
    }; 
  };
}
