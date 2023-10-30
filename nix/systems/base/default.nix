{ ... }:
{
  imports = [
    ./configuration.nix
    ./networking.nix
    ./services.nix
    ./virtulization.nix
    ./packages.nix
    ./ssh.nix
  ];
}
