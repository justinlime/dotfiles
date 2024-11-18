{ pkgs, lib, ... }:
let
  catppuccin-mocha = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "btop";
    rev = "c6469190f2ecf25f017d6120bf4e050e6b1d17af";
    hash = "sha256-jodJl4f2T9ViNqsY9fk8IV62CrpC5hy7WK3aRpu70Cs=";
  };
in
{
  programs.btop = {
    enable = true;
    settings = {
      color_theme = "catppuccin-mocha";
      theme_background = false;
      vim_keys = true;
      update_ms = 500;
    };
  };
  xdg.configFile = {
    "btop/themes/catppuccin-mocha.theme" = {
      source = "${catppuccin-mocha}/themes/catppuccin_mocha.theme";
    };
  };
}
