{ ... }:
{
  systemd.tmpfiles.rules = [
    "d /configs/jellyseerr 0755 justinlime justinlime -" #The - disables automatic cleanup, so the file wont be removed after a period
  ];
  virtualisation.oci-containers.containers = {
    jellyseerr = {
     autoStart = true; 
     image = "ghcr.io/fallenbagel/jellyseerr:latest";
     environment = {
       TZ = "America/Chicago";
       PORT = "5055";
     };
     ports = [ "5055:5055" ];
     networks = [ "network" ];
     volumes = [
       "/configs/jellyseerr:/app/config"
     ];
   };  
  };
  services.nginx = {
    enable = true;
    virtualHosts = {
      "request.justin-li.me" = {
        serverName = "request.justin-li.me";
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyWebsockets = true;
          recommendedProxySettings = true;
          proxyPass = "http://127.0.0.1:5055";
        };
      };
    };
  };
}
