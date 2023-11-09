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
    zsh.enable = true;
    zsh.shellAliases = {
      nix-switch = "sudo nixos-rebuild switch --flake path:${flake_path}#stinkserver";
      testpoop = "echo testpoop1";
    };
  };

  networking.hostName = "stinkserver";

  environment.systemPackages = with pkgs; [
    mergerfs
    snapraid
    intel-gpu-tools
    ffmpeg-full
  ];
}
