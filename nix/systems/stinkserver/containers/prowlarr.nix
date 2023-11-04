{ ... }:
{
  virtualisation.oci-containers.containers = {
    prowlarr = {
     autoStart = true; 
     image = "lscr.io/linuxserver/prowlarr:latest";
     environment = {
       TZ = "America/Chicago";
       PUID = "1000";
       PGID = "100";
     };
     ports = [ "9696:9696" ];
     volumes = [
       "/configs/prowlarr:/config"
     ];
    };  
  };
}
