{ pkgs, flake_path, ... }:
{
    imports =
        [ # Include the results of the hardware scan.
        ./hardware-configuration.nix
        ../base
        ];

    # System
    programs.steam.enable = true;
    environment = {
        systemPackages = with pkgs; [
          mangohud
        ];
    };
}
