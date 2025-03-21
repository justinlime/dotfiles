{ ... }:
{
  systemd.tmpfiles.rules = [
    "d /configs/jellyfin 0755 justinlime justinlime -" #The - disables automatic cleanup, so the file wont be removed after a period
  ];
  networking.firewall.allowedTCPPorts = [ 8096 ];
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
    ];
     extraOptions = [ "--network=host" "--device=/dev/dri/renderD128:/dev/dri/renderD128" "--device=/dev/dri/card0:/dev/dri/card0" ];
    };  
  };
  services.nginx = {
    enable = true;
    virtualHosts = {
      "watch.stinkboys.com" = {
        listen = [{
          port = 90;
          addr = "0.0.0.0";
        }
        ];
        locations."/" = {
          proxyPass = "http://localhost:8096";
          extraConfig = ''
            # Proxy main Jellyfin traffic
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
            proxy_set_header X-Forwarded-Protocol $scheme;
            proxy_set_header X-Forwarded-Host $http_host;
            proxy_read_timeout 600s;
            proxy_send_timeout 600s;
            # Disable buffering when the nginx proxy gets very resource heavy upon streaming
            proxy_buffering off;
          '';
        };
        locations."/socket" = {
          proxyPass = "http://localhost:8096";
          extraConfig = ''
            # Proxy Jellyfin Websockets traffic
            proxy_http_version 1.1;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection "upgrade";
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
            proxy_set_header X-Forwarded-Protocol $scheme;
            proxy_set_header X-Forwarded-Host $http_host;
          '';
        };
      };
    };
  };
}
