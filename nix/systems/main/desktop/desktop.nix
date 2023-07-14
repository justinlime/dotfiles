{ config, pkgs, lib, ... }:
{
    imports =
        [ # Include the results of the hardware scan.
        ./hardware-configuration.nix
        ../base/configuration.nix
        ../base/packages.nix
        ../base/services.nix
        ];

    # System
    networking.hostName = "jesktop";

    #Programs
    programs.zsh.shellAliases.nix-switch = "sudo nixos-rebuild switch --flake /home/justinlime/dotfiles#jesktop";
}
