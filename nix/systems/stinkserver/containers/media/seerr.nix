{ ... }:
{
  virtualisation.oci-containers.containers = {
    seerr = {
     autoStart = true; 
     image = "ghcr.io/seerr-team/seerr:latest";
     environment = {
       TZ = "America/Chicago";
       PORT = "5055";
     };
     ports = [ "5055:5055" ];
     networks = [ "network" ];
     volumes = [
       "/containers/seerr:/app/config"
     ];
     extraOptions = [ "--init" ];
   };  
  };
}
