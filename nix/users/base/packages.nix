{ pkgs, inputs, ... }:
{
  fonts.fontconfig.enable = true;
  #Packages
  home.packages = with pkgs; [
    speedtest-cli
    gcc
    vrrtest
    websocat
    (nerdfonts.override { fonts = [ "RobotoMono" ]; })
  ];
}
