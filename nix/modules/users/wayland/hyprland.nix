{ pkgs, lib, config, jlib, inputs, ... }:
let
  cfg = config.homeMods.hyprland;
  theme = config.homeMods.theme;
  palette = jlib.fullPalette theme.palette;
in
{
  options.homeMods.hyprland = with lib.types; {
    enable = lib.mkEnableOption "Enable";
  };
  config = lib.mkIf cfg.enable {
    homeMods.foot.enable = lib.mkForce true;
    wayland.windowManager.hyprland = {
      enable = true;
      extraConfig = builtins.readFile "${inputs.self}/non-nix/hypr/hyprland.conf";
    };
  };
}
