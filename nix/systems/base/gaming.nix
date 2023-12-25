{ pkgs, ... }:
{
  # System
  programs = {
    steam.enable = true;
  };
  hardware = {
    opengl.enable = true; 
  };
  environment = {
    systemPackages = with pkgs; [
      mangohud
    ];
  };

}
