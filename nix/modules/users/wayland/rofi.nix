{ lib, config, jlib, ... }:
let
  cfg = config.homeMods.rofi;
  theme = config.homeMods.theme;
  palette = jlib.fullPalette theme.palette;
in
  {
    options.homeMods.rofi = with lib.types; {
      enable = lib.mkEnableOption "Enable";
    };
    config = lib.mkIf cfg.enable {
      # xdg.configFile."rofi/config.rasi".text =  (import ./theme.nix { inherit config lib; });
      programs.rofi = {
        enable = true;
        theme = let
        mkL = config.lib.formats.rasi.mkLiteral;
        in {
          "*" = {
            font = "${theme.font.name} ${builtins.toString (theme.font.size + 10)}";
            text-color = mkL "rgb(${palette.rgbComma.text})";
            background-color = mkL "rgb(${palette.rgbComma.crust})";
          };
          "window" = {
            height = mkL "20em";
            width = mkL "30em";
            border-radius = mkL "8px";
            border-width = mkL "2px";
            padding = mkL "1.5em";
          };
          "mainbox" = {
            background-color = mkL "rgb(${palette.rgbComma.crust})";
          };
          "inputbar" = {
            margin = mkL "0 0 1em 0";
          };
          "prompt" = {
            enabled = false;
          };
          "entry" = {
            placeholder = "Search...";
            padding = mkL "1em 1em";
            text-color = mkL "rgb(${palette.rgbComma.overlay0})";
            background-color = mkL "rgb(${palette.rgbComma.base})";
            border-radius = mkL "8px";
          };
          "element-text" = {
            padding = mkL "0.5em 1em";
            margin = mkL "0 0.5em";
          };
          "element-icon" = {
            size = mkL "3ch";
          };
          "element-text selected" = {
            background-color = mkL "rgb(${palette.rgbComma.mauve})";
            text-color = mkL "rgb(${palette.rgbComma.crust})";
            border-radius = mkL "8px";
          };
        };
      };
    };
  }
