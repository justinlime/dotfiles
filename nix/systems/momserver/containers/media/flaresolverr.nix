{ ... }:
{
  virtualisation.oci-containers.containers = {
    flaresolverr = {
     autoStart = true; 
     image = "ghcr.io/flaresolverr/flaresolverr:latest";
     environment = {
       TZ = "America/Chicago";
     };
     ports = [ "8191:8191" ];
     networks = [ "network" ];
   };  
  };
}
