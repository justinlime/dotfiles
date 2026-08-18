{ pkgs, config, inputs, lib, ... }:
let cfg = config.homeMods.ghostty; in 
{
  options.homeMods.ghostty = with lib.types; {
    enable = lib.mkEnableOption  "Enable"; 
  };
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      ghostty  
      nerd-fonts.fira-code
    ];
    xdg.configFile = {
      "ghostty/config.ghostty".source = "${inputs.self}/non-nix/ghostty/config.ghostty";
      "ghostty/themes/catppuccin-mocha.conf".source = "${inputs.self}/non-nix/ghostty/themes/catppuccin-mocha.conf";
    };
  };
}
