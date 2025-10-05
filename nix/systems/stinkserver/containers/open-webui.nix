{ ... }:
{
  systemd.tmpfiles.rules = [
    "d /configs/open-webui 0755 justinlime justinlime -" #The - disables automatic cleanup, so the file wont be removed after a period
    "d /configs/open-webui/data 0755 justinlime justinlime -" #The - disables automatic cleanup, so the file wont be removed after a period
  ];
  virtualisation.oci-containers.containers = {
    open-webui = {
     autoStart = true; 
     image = "ghcr.io/open-webui/open-webui:main";
     ports = [ "4242:8080" ];
     volumes = [
       "/configs/open-webui/data:/app/backend/data"
    ];
    };  
  };
  services.nginx = {
    enable = true;
    virtualHosts = {
      "ai.justin-li.me" = {
        serverName = "ai.justin-li.me";
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          recommendedProxySettings = true;
          proxyWebsockets = true;
          proxyPass = "http://127.0.0.1:4242";
        };
      };
    };
  };
}
