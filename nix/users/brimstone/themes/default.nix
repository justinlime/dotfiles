{ pkgs, custom, ... }:
{
    imports = [
        (import ./gtk.nix { inherit pkgs custom; })
        ./qt.nix
    ];
}
