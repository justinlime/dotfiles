{ config, pkgs, lib, ... }:
let
  cfg = config.homeMods.btop;
  catppuccin-mocha = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "btop";
    rev = "c6469190f2ecf25f017d6120bf4e050e6b1d17af";
    hash = "sha256-jodJl4f2T9ViNqsY9fk8IV62CrpC5hy7WK3aRpu70Cs=";
  };
in
{
  options.homeMods.btop = with lib.types; {
    enable = lib.mkEnableOption "Enable"; 
    update_ms = lib.mkOption {
      default = 500;
      type = int;
    };
  };
  config = lib.mkIf cfg.enable {
    programs.btop = {
      enable = true;
      settings = {
        color_theme = "catppuccin-mocha";
        theme_background = false;
        vim_keys = true;
        update_ms = cfg.update_ms;
      };
    };
    xdg.configFile = {
      "btop/themes/catppuccin-mocha.theme" = {
        source = "${catppuccin-mocha}/themes/catppuccin_mocha.theme";
      };
    };
  };
}
