{ ... }:
{
  # A complete wayland experience with Hyprland :)
  imports = [
    ./hyprland.nix
    ./waybar.nix
    ./wofi.nix 
    ./foot.nix
  ];
}
