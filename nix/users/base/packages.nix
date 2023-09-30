{ pkgs, inputs, ... }:
{
  fonts.fontconfig.enable = true;
  #Packages
  home.packages = with pkgs; [
    speedtest-cli
    gcc
    emacs29
    vrrtest
    websocat
    (nerdfonts.override { fonts = [ "RobotoMono" ]; })
  ];
}
