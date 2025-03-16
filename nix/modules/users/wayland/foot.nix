{ config, lib, ... }:
let
  cfg = config.homeMods.foot;
  theme = config.homeMods.theme;
  palette = theme.palette;
in 
{
  options.homeMods.foot = with lib.types; {
    enable = lib.mkEnableOption  "Enable"; 
  };
  config = lib.mkIf cfg.enable {
    homeMods.theme.enable = lib.mkForce true;
    programs.foot = {
      enable = true;
      server.enable = true;
      settings = {
        main = {
          term = "xterm-256color";
          font = "${theme.font.name}:size=${builtins.toString theme.font.size}";
          pad = "15x15 center";
          dpi-aware = "no";
        };
        cursor = {
          color = "${palette.mauve} ${palette.mauve}";
          style = "beam";
        };
        colors = rec {
          alpha="1.0";
          background="${palette.crust}";
          # background="${custom.background}";
          regular0="${palette.subtext0}";  # black
          regular1="${palette.red}";  # red
          regular2="${palette.green}";  # green
          regular3="${palette.yellow}";  # yellow
          regular4="${palette.blue}";  # blue
          regular5="${palette.mauve}";  # magenta
          regular6="${palette.sky}";  # cyan
          regular7="${palette.text}";  # white
          bright0= regular0; # bright black
          bright1= regular1; # bright red
          bright2= regular2;   # bright green
          bright3= regular3;   # bright yellow
          bright4= regular4;   # bright blue
          bright5= regular5;   # bright magenta
          bright6= regular6;   # bright cyan
          bright7= regular7;   # bright white
        };
        tweak = {
          sixel = "yes";
        };
      };
    };
  };
}
