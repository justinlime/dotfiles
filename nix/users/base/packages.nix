{ pkgs, inputs, ... }:
{
  fonts.fontconfig.enable = true;
  #Packages
  home.packages = with pkgs; [
    speedtest-cli
    gcc
    vrrtest
    websocat
	roboto
    (nerdfonts.override { fonts = [ "RobotoMono" ]; })
  ];
}
