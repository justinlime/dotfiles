{ pkgs, inputs, flake_path, ... }:
{
  imports = [ 
    ./hardware-configuration.nix
    ./containers
    ./services
    ../base/configuration.nix
    ../base/ssh.nix
    ../base/docker.nix
    ../base/networking.nix
  ];

  networking = {
   hostName = "stinkserver"; 
   nameservers = ["9.9.9.9"];
  };

  environment.systemPackages = with pkgs; [
    mergerfs
    snapraid
    intel-gpu-tools
    ffmpeg-full
    linux-firmware
    # inputs.pipecord.packages.${pkgs.system}.default
  ];
}
