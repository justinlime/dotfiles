{ pkgs, inputs, ... }:
{
  fonts.fontconfig.enable = true;
  #Packages
  home.packages = with pkgs; [
    speedtest-cli
    ventoy
    gcc
    vrrtest
    websocat
		roboto
		pciutils
    tree
    (nerdfonts.override { fonts = [ "RobotoMono" ]; })
  ];
}
