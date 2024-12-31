{ config, lib, ... }:
let
  cfg = config.jfg.mpv;
in 
{

  options.jfg.mpv = {
   enable = lib.mkEnableOption "Enable"; 
  };
  config = lib.mkIf cfg.enable {
    programs.mpv = {
      enable = true;
      bindings = {
        "Ctrl+s" = "playlist-shuffle";
      };
    }; 
  };
}
