{ ... }:
{
  systemd.tmpfiles.rules = [
    "d /configs/jellyfin 0755 justinlime justinlime -" #The - disables automatic cleanup, so the file wont be removed after a period
  ];
  networking.firewall.allowedTCPPorts = [ 8096 80 443 ];
  networking.firewall.allowedUDPPorts = [ 7359 1900 ];
  virtualisation.oci-containers.containers = {
    jellyfin = {
     autoStart = true; 
     image = "lscr.io/linuxserver/jellyfin:latest";
     environment = {
       TZ = "America/Chicago";
       PUID = "1000";
       PGID = "100";
       JELLYFIN_PublishedServerUrl = "http://10.0.0.200";
     };
     ports = [ "8096:8096" "8920:8920" "1900:1900/udp" "7359:7359/udp" ];
     volumes = [
       "/configs/jellyfin:/config"
       "/storage/pool/media/watch/movies:/movies"
       "/storage/pool/media/watch/tv:/tv"
       "/storage/pool/media/watch/anime:/anime"
       "/storage/pool/media/watch:/watch"
       "/storage/pool/media/listen:/listen"
    ];
     extraOptions = [ "--network=host" "--device=/dev/dri/renderD128:/dev/dri/renderD128" "--device=/dev/dri/card1:/dev/dri/card1" ];
    };  
  };
  security.acme = {
    acceptTerms = true;
    defaults.email = "justinlime1999@gmail.com";
  };
  services.nginx = {
    enable = true;
    virtualHosts = {
      "watch.stinkboys.com" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:8096";
        };
        locations."/socket" = {
          proxyPass = "http://localhost:8096";
        };
      };
    };
  };
}
