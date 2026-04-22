{ pkgs, lib, config, ... }:
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
    # kde.enable = true;
    gnomerdp.enable = true;
    firewall = {
      enable = true;  
      TCPPorts = [ 1313 1314 5002 10200 3999 51820 8281 ];
      BothPorts = [ 1313 1314 5002 10200 3999 51820 8281 ];
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
     allowedTCPPortRanges = [ { from = 1300; to = 1320; } ];
     allowedTCPPorts = [ 1313 1314 ];
     allowedUDPPorts = [ 1313 1314 ];
   };
  };
  security.acme = {
    acceptTerms = true;
    defaults.email = "justinlime1999@gmail.com";
  };
  systemd.targets.sleep.enable = false;
  systemd.targets.suspend.enable = false;
  systemd.targets.hibernate.enable = false;
  systemd.targets.hybrid-sleep.enable = false;
  systemd.services.podman-create-pod = {
    serviceConfig.Type = "oneshot";
    wantedBy = [ "multi-user.target" ];
    script = ''
      ${pkgs.podman}/bin/podman network exists network || \
      ${pkgs.podman}/bin/podman network create --subnet 192.168.69.0/24 network
    '';
  };
  environment.systemPackages = with pkgs; [
    mergerfs
    snapraid
    intel-gpu-tools
    # (ffmpeg-full.override { withSvtav1 = true; svt-av1=pkgs.svt-av1-psy; })
    linux-firmware
  ];
}
 
