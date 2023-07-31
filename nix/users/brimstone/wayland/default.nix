{ custom, ... }:
{
    imports = [
        (import ./hyprland.nix { inherit custom; })
        (import ./waybar.nix { inherit custom; })
        (import ./wofi.nix { inherit custom; })
        (import ./foot.nix { inherit custom; })
    ];
}
