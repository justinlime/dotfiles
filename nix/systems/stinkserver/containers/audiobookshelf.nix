{ ... }:
{
  systemd.tmpfiles.rules = [
    "d /configs/audiobookshelf 0755 justinlime justinlime -" #The - disables automatic cleanup, so the file wont be removed after a period
  ];
  virtualisation.oci-containers.containers = {
    audiobookshelf = {
     autoStart = true; 
     image = "advplyr/audiobookshelf:latest";
     environment = {
       TZ = "America/Chicago";
       PUID = "1000";
       PGID = "100";
     };
     ports = [ "1337:80" ];
     volumes = [
       "/configs/audiobookshelf:/config"
       "/configs/audiobookshelf:/metadata"
       "/storage/pool/media/listen:/listen"
    ];
    };  
  };
  services.nginx = {
    enable = true;
    virtualHosts = {
      "listen.stinkboys.com" = {
        listen = [{
          port = 90;
          addr = "0.0.0.0";
        }
        ];
        locations."/" = {
          proxyPass = "http://localhost:1337";
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
          proxyPass = "http://localhost:1337";
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
