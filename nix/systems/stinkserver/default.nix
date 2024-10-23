{ pkgs, inputs, username, hush, flake_path, ... }:
{
  imports = [ 
    ./hardware-configuration.nix
    ./containers
    ./services
    ../base/configuration.nix
    ../base/ssh.nix
    ../base/docker.nix
    ../base/networking.nix
    ../base/usb.nix
    ../base/avahi.nix
    ../base/smart.nix
    ../base/xrdp.nix
    ../base/virtulization.nix
  ];

  networking = {
   hostName = "stinkserver"; 
   nameservers = ["9.9.9.9"];
   firewall = {
      allowedTCPPorts = [ 1313 ];
      allowedUDPPorts = [ 1313 ];
   };
  };
  users.users.${username}.openssh.authorizedKeys.keys = [
    "${hush.ssh.public-keys.stinkserver}" 
  ];
  environment.systemPackages = with pkgs; [
    mergerfs
    snapraid
    intel-gpu-tools
    ffmpeg-full
    linux-firmware
    # inputs.pipecord.packages.${pkgs.system}.default
  ];
}
 
