{ lib, config, jlib, ... }:
let
  cfg = config.homeMods.hyprlock;
  theme = config.homeMods.theme;
  palette = jlib.fullPalette theme.palette;
in
{
  options.homeMods.hyprlock = with lib.types; {
    enable = lib.mkEnableOption "Enable";
  };
  config = lib.mkIf cfg.enable {
    programs.hyprlock = {
      enable = true;
      settings = {
        general = {
          disable_loading_bar = true;
          grace = 30;
          hide_cursor = true;
          no_fade_in = false;
          no_fade_out = false;
        };

        background = [
          {
            path = "~/photos/wallpapers/wallpaper.png";
            blur_passes = 3;
            blur_size = 8;
          }
        ];
        label = {
          text = "Locked"; 
          text_align = "center";
          font_size = 50;
          halign = "center";
          valign = "center";
          position = "0, 80";
        };
        input-field = [
          {
            size = "200, 50";
            position = "0, -80";
            # Leave monitor empty for all monitors
            monitor = "";
            dots_center = true;
            fade_on_empty = false;
            font_color = "rgb(${palette.rgbComma.text})";
            inner_color = "rgb(${palette.rgbComma.crust})";
            outer_color = "rgb(${palette.rgbComma.crust})";
            outline_thickness = 5;
            placeholder_text = "";
            shadow_passes = 0;
          }
        ];
      };
    };
  };
}
