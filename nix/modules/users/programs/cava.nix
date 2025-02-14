{ lib, config, ... }:
let cfg = config.homeMods.cava; in 
{
  options.homeMods.cava = {
   enable = lib.mkEnableOption "Enable"; 
  };

  config = lib.mkIf cfg.enable {
    programs.cava = {
      # Build failing, gotta disable
      enable = true;
      settings = {
        general = {
          framerate = 60;
        };
        color = {
          gradient = 1;
          gradient_color_1 = "'#94e2d5'";
          gradient_color_2 = "'#89dceb'";
          gradient_color_3 = "'#74c7ec'";
          gradient_color_4 = "'#89b4fa'";
          gradient_color_5 = "'#cba6f7'";
          gradient_color_6 = "'#f5c2e7'";
          gradient_color_7 = "'#eba0ac'";
          gradient_color_8 = "'#f38ba8'";
          gradient_color_9 = "'#f38ba8'";
          gradient_color_10 = "'#f38ba8'";
        };
      };
    };
  };
}
