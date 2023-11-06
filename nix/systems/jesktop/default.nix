{ pkgs, flake_path, ... }:
{
    imports =
        [ # Include the results of the hardware scan.
        ./hardware-configuration.nix
        ../base
        ];

    # System
    programs = {
      steam.enable = true;
      zsh.shellAliases = {
        nix-switch = "sudo nixos-rebuild switch --flake path:${flake_path}#jesktop";
      };
    };

    networking.hostName = "jesktop";

    environment = {
        systemPackages = with pkgs; [
          mangohud
        ];
    };
}
