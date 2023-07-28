{ ... }:
{
    imports =
        [ # Include the results of the hardware scan.
        ./hardware-configuration.nix 
        ../base
        ];

    # System
    networking.hostName="japtop";

    #Programs
    programs = {
        zsh.shellAliases.nix-switch = "sudo nixos-rebuild switch --flake /home/justinlime/dotfiles#japtop";
        light.enable = true;
    };

    #Services
    services = {
        tlp.enable = true;
    };
}
