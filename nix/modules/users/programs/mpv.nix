{ config, lib, ... }:
let
  cfg = config.homeMods.mpv;
in 
{

  options.homeMods.mpv = {
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
