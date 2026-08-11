{ ... }:
{
  virtualisation.oci-containers.containers = {
    sonarr = {
     autoStart = true; 
     image = "lscr.io/linuxserver/sonarr:latest";
     environment = {
       TZ = "America/Chicago";
       PUID = "1000";
       PGID = "100";
     };
     ports = [ "8989:8989" ];
     networks = [ "network" ];
     volumes = [
       "/containers/sonarr:/config"
       "/storage/downloads:/downloads"
       "/storage/pool/media/watch/tv:/tv"
     ];
   };  
  };
}
