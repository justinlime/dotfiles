{ ... }:
{
  # Import everything
  imports = [
    ./configuration.nix
    ./networking.nix
    ./docker.nix
    ./wayland.nix
    ./virtulization.nix
    ./ssh.nix
    ./gaming.nix
  ];
}
