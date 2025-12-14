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
     networks = [ "network" ];
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
        serverName = "listen.stinkboys.com";
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          recommendedProxySettings = true;
          proxyWebsockets = true;
          proxyPass = "http://127.0.0.1:1337";
        };
      };
      "listen.justin-li.me" = {
        serverName = "listen.justin-li.me";
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          recommendedProxySettings = true;
          proxyWebsockets = true;
          proxyPass = "http://127.0.0.1:1337";
        };
      };
    };
  };
}
