{ ... }:
{
  imports = [ 
    ./hardware-configuration.nix
    ../base/configuration.nix
    ../base/docker.nix
  ];
}
