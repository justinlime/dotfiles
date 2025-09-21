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

  security.acme = {
    acceptTerms = true;
    defaults.email = "justinlime1999@gmail.com";
  };
  services.nginx = {
    enable = true;
    virtualHosts = {
      "listen.stinkboys.com" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyWebsockets = true;
          proxyPass = "http://localhost:1337";
        };
      };
    };
  };
}
