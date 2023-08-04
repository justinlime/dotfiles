{ pkgs, inputs, ... }:
{
  fonts.fontconfig.enable = true;
  #Packages
  home.packages = with pkgs; [
    speedtest-cli
    gcc
    (nerdfonts.override { fonts = [ "RobotoMono" ]; })
  ];
}
