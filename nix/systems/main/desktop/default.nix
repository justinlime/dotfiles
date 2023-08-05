{ pkgs, flake_path, ... }:
{
    imports =
        [ # Include the results of the hardware scan.
        ./hardware-configuration.nix
        ../base
        ];

    # System
    networking.hostName = "jesktop";
    programs.steam.enable = true;
    environment = {
        systemPackages = with pkgs; [
          mangohud
        ];
    };


    #Programs
    programs.zsh.shellAliases.nix-switch = "sudo nixos-rebuild switch --flake ${flake_path}#jesktop";
}
