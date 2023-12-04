{ pkgs, inputs, flake_path, ... }:
{
  imports = [ 
    ./hardware-configuration.nix
    ./containers
    ./services
    ../base/configuration.nix
    ../base/ssh.nix
    ../base/docker.nix
  ];

  networking.hostName = "stinkserver";

  environment.systemPackages = with pkgs; [
    mergerfs
    snapraid
    intel-gpu-tools
    ffmpeg-full
    linux-firmware
    # inputs.pipecord.packages.${pkgs.system}.default
  ];
}
