{ pkgs, ... }:
{
  imports = [ 
    ./hardware-configuration.nix
    ./containers
    ./services
    ../base/configuration.nix
    ../base/ssh.nix
    ../base/docker.nix
  ];

  environment.systemPackages = with pkgs; [
    mergerfs
    snapraid
  ];
}
