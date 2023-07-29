{ 
    pkgs, 
    custom ? {
        font = "RobotoMono Nerd Font";
        fontsize = "12";
        accent = "cba6f7";
        background = "11111B";
        opacity = ".85";
        cursor = "Numix-Cursor";
    }, 
    ... }:
{
    imports = [
        (import ./gtk.nix { inherit pkgs custom; })
        ./qt.nix
    ];
}
