{ flake_path, ... }:
{
    imports =
        [ # Include the results of the hardware scan.
        ./hardware-configuration.nix
        ../base
        ];

    # System
    networking.hostName = "jesktop";

    #Programs
    programs.zsh.shellAliases.nix-switch = "sudo nixos-rebuild switch --flake ${flake_path}#jesktop";
}
