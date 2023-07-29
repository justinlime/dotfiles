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
        (import ./hyprland.nix { inherit custom; })
        (import ./waybar.nix { inherit custom; })
        (import ./wofi.nix { inherit custom; })
        (import ./foot.nix { inherit custom; })
    ];
}
