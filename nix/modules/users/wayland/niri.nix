{ pkgs, lib, config, jlib, inputs, ... }:
let
  cfg = config.homeMods.niri;
in
{
  options.homeMods.niri = with lib.types; {
    enable = lib.mkEnableOption "Enable";
  };
  config = lib.mkIf cfg.enable {
    homeMods.foot.enable = lib.mkForce true;
    xdg.configFile = {
      "niri/config.kdl".source = "${inputs.self}/non-nix/niri/config.kdl";
    };
  };
}
