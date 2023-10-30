{ inputs, home_profile, username, flake_path, ... }:
let 
  # Variables to share accross configs
  custom = {
    font = "RobotoMono Nerd Font";
    fontsize = "12";
    primary_accent = "cba6f7";
    secondary_accent= "89b4fa";
    tertiary_accent = "f5f5f5";
    background = "11111B";
    opacity = "1";
    cursor = "Numix-Cursor";
    palette = import ./colors;
  };
in
{
  # Brimstone is my main everyday home configuration, including a number
  # of tools and services i use on a daily basis
  _module.args = { inherit inputs username custom; };
  imports = [ 
    ./general
    ./programs
    ./themes
    ./wayland
    ../base
  ];
}
