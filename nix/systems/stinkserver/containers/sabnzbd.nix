{ ... }:
{
  systemd.tmpfiles.rules = [
    "d /configs/sabnzbd 0755 justinlime justinlime -" #The - disables automatic cleanup, so the file wont be removed after a period
  ];
  # Set paths in sabnzbd itself to ensure it functions as intended
  virtualisation.oci-containers.containers = {
    sabnzbd = {
     autoStart = true; 
     image = "lscr.io/linuxserver/sabnzbd:latest";
     environment = {
       TZ = "America/Chicago";
       PUID = "1000";
       PGID = "100";
     };
     ports = [ "8081:8080" ];
     volumes = [
       "/configs/sabnzbd:/config"
       "/storage/downloads:/downloads"
     ];
   };  
  };
}
