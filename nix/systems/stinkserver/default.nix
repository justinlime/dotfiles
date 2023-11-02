{ pkgs, ... }:
{
  imports = [ 
    ./hardware-configuration.nix
    ./containers.nix
    ./samba.nix
    ../base/configuration.nix
    ../base/ssh.nix
    ../base/docker.nix
  ];
  environment.systemPackages = with pkgs; [
    mergerfs
    compsize
  ];
}
