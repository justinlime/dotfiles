{ pkgs, flake_path, ... }:
{
  imports = [ 
    ./hardware-configuration.nix
    ./containers
    ./services
    ../base/configuration.nix
    ../base/ssh.nix
    ../base/docker.nix
  ];

  programs = {
    zsh.shellAliases = {
      nix-switch = "sudo nixos-rebuild switch --flake path:${flake_path}#stinkserver";
    };
  };

  networking.hostName = "stinkserver";

  environment.systemPackages = with pkgs; [
    mergerfs
    snapraid
  ];
}
