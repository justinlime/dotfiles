{ config, lib, pkgs, ... }:
let cfg = config.sysMods.hyprland; in 
{
  options.sysMods.hyprland = with lib.types; {
    enable = lib.mkEnableOption "Enable";
  };

  config = lib.mkIf cfg.enable {
    programs.hyprland.enable = true;
    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";  
      HYPR_PLUGIN_DIR = pkgs.symlinkJoin {
        name = "hyprland-plugins";
        paths = with pkgs.hyprlandPlugins; [
          hyprscrolling 
        ];
      };
    };
    xdg.portal = {
      enable = true;
    };
  };
}
