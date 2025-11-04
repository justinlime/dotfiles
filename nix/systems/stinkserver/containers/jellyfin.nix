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
     image = "lscr.io/linuxserver/jellyfin:10.11.0";
     environment = {
       TZ = "America/Chicago";
       PUID = "1000";
       PGID = "100";
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
     extraOptions = [ "--network=host" "--device=/dev/dri/a380-render:/dev/dri/renderD128" "--device=/dev/dri/a380-card:/dev/dri/card0" ];
    };  
  };
  services.nginx = {
    enable = true;
    virtualHosts = {
      "watch.stinkboys.com" = {
        serverName = "watch.stinkboys.com";
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          recommendedProxySettings = true;
          proxyWebsockets = true;
          proxyPass = "http://127.0.0.1:8096";
        };
      };
      "watch.justin-li.me" = {
        serverName = "watch.justin-li.me";
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyWebsockets = true;
          recommendedProxySettings = true;
          proxyPass = "http://127.0.0.1:8096";
        };
      };
    };
  };
}
