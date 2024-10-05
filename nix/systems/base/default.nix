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
    ./smart.nix
    ./avahi.nix
    ./usb.nix
    ./xrdp.nix
  ];
}
