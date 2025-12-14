{ ... }:
{
  systemd.tmpfiles.rules = [
    "d /configs/sonarr 0755 justinlime justinlime -" #The - disables automatic cleanup, so the file wont be removed after a period
  ];
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
       "/configs/sonarr:/config"
       "/storage/downloads:/downloads"
       "/storage/pool/media/watch/tv:/tv"
     ];
   };  
  };
}
