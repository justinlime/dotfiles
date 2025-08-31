{ pkgs, config, hush, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./containers
    ./services
  ];
  sysMods = {
    system = rec {
      username = "justinlime";  
      flakeDirectory = "/home/${username}/dotfiles";
    }; 
    smart.enable = true;
    ssh.enable = true;
    usbautomount.enable = true;
    virt.enable = true;
    gnomerdp.enable = true;
    firewall = {
      enable = true;  
      TCPPorts = [ 1313 ];
      BothPorts = [ 1313 ];
    };
  };
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    audio.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };
  services.flatpak.enable = true;
  networking = {
   hostName = "stinkserver"; 
   firewall = {
      allowedTCPPorts = [ 1313 ];
      allowedUDPPorts = [ 1313 ];
   };
  };
  users.users.${config.sysMods.system.username}.openssh.authorizedKeys.keys = [
    "${hush.ssh.public-keys.stinkserver}" 
  ];
  environment.systemPackages = with pkgs; [
    mergerfs
    snapraid
    intel-gpu-tools
    # (ffmpeg-full.override { withSvtav1 = true; svt-av1=pkgs.svt-av1-psy; })
    linux-firmware
    # inputs.pipecord.packages.${pkgs.system}.default
  ];
}
 
