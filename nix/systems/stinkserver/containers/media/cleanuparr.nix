{ ... }:
{
  virtualisation.oci-containers.containers = {
    cleanuparr = {
     autoStart = true; 
     image = "ghcr.io/cleanuparr/cleanuparr:latest";
     environment = {
       TZ = "America/Chicago";
       PUID = "1000";
       PGID = "100";
       PORT = "11011";
     };
     ports = [ "11011:11011" ];
     networks = [ "network" ];
     volumes = [
       "/containers/cleanuparr:/config"
     ];
   };  
  };
}
