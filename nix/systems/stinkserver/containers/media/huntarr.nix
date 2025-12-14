{ ... }:
{
  systemd.tmpfiles.rules = [
    "d /configs/huntarr 0755 justinlime justinlime -" #The - disables automatic cleanup, so the file wont be removed after a period
  ];
  virtualisation.oci-containers.containers = {
    huntarr = {
     autoStart = true; 
     image = "ghcr.io/plexguide/huntarr:latest";
     environment = {
       TZ = "America/Chicago";
       PUID = "1000";
       PGID = "100";
     };
     ports = [ "9705:9705" ];
     networks = [ "network" ];
     volumes = [
       "/configs/huntarr:/config"
     ];
   };  
  };
}
