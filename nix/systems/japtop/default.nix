{ flake_path, ... }:
{
    imports =
        [ # Include the results of the hardware scan.
        ./hardware-configuration.nix 
        ../base
        ];

    #Programs
    programs = {
      light.enable = true;
      zsh.shellAliases = {
        nix-switch = "sudo nixos-rebuild switch --flake path:${flake_path}#japtop";
      };
    };

    networking.hostName = "japtop";
    #Services
    services = {
        tlp.enable = true;
    };
}
