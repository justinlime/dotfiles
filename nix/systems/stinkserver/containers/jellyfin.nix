{ ... }:
{
  systemd.tmpfiles.rules = [
    "d /configs/jellyfin 0755 justinlime justinlime -" #The - disables automatic cleanup, so the file wont be removed after a period
  ];
  networking.firewall.allowedTCPPorts = [ 80 90 8096 ];
  networking.firewall.allowedUDPPorts = [ 7359 ];
  virtualisation.oci-containers.containers = {
    jellyfin = {
     autoStart = true; 
     image = "lscr.io/linuxserver/jellyfin:latest";
     environment = {
       TZ = "America/Chicago";
       PUID = "1000";
       PGID = "100";
       JELLYFIN_PublishedServerUrl = "http://192.168.4.59";
     };
     ports = [ "8096:8096" "8920:8920" "1900:1900/udp" "7359:7359/udp" ];
     volumes = [
       "/configs/jellyfin:/config"
       "/storage/pool/media/watch/movies:/movies"
       "/storage/pool/media/watch/tv:/tv"
       "/storage/pool/media/watch/anime:/anime"
    ];
     extraOptions = [ "--network=host" "--device=/dev/dri/renderD128:/dev/dri/renderD128" "--device=/dev/dri/card1:/dev/dri/card1" ];
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
            proxy_set_header Accept-Encoding "";
            sub_filter 
            '</body>' 
            '<script plugin="Jellyscrub" version="1.0.0.0" src="/Trickplay/ClientScript"></script>
            </body>';  
            sub_filter_once on; 
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
            proxy_set_header X-Forwarded-Protocol $scheme;
            proxy_set_header X-Forwarded-Host $http_host;
          '';
        };
        locations."/socket" = {
          proxyPass = "http://localhost:8096";
          extraConfig = ''
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
