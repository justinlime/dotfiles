{ ... }:
{
  virtualisation.oci-containers.containers = {
    requestrr = {
     autoStart = true; 
     image = "ghcr.io/hotio/requestrr";
     environment = {
       TZ = "America/Chicago";
       PUID = "1000";
       PGID = "100";
     };
     ports = [ "4545:4545" ];
     networks = [ "network" ];
     volumes = [
       "/containers/requestrr:/config"
     ];
   };  
  };
}
