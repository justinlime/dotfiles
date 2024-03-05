{ hush, ... }:
{
  virtualisation.oci-containers.containers = {
    duckdns = {
     autoStart = true; 
     image = "lscr.io/linuxserver/duckdns:latest";
     environment = {
       TZ = "America/Chicago";
       PUID = "1000";
       PGID = "100";
       SUBDOMAINS = "${hush.duckdns.stinkserver.subdomain}";
       TOKEN = "${hush.duckdns.token}";
       UPDATE_IP = "ipv4";
     };
     volumes = [
       "/configs/duckdns:/config"
     ];
    };  
  };
}
