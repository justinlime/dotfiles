{ ... }:
{
  systemd.tmpfiles.rules = [
    "d /configs/seerr 0755 justinlime justinlime -" #The - disables automatic cleanup, so the file wont be removed after a period
  ];
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
       "/configs/seerr:/app/config"
     ];
     extraOptions = [ "--init" ];
   };  
  };
}
