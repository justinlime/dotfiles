{ ... }:
{
  systemd.tmpfiles.rules = [
    "d /configs/prowlarr 0755 justinlime justinlime -" #The - disables automatic cleanup, so the file wont be removed after a period
  ];
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
     networks = [ "network" ];
     volumes = [
       "/configs/prowlarr:/config"
     ];
   };  
  };
}
