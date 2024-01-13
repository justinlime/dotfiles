{ ... }:
{
  systemd.tmpfiles.rules = [
    "d /configs/radarr_mom 0755 justinlime justinlime -" #The - disables automatic cleanup, so the file wont be removed after a period
  ];
  virtualisation.oci-containers.containers = {
    radarr_mom = {
     autoStart = true; 
     image = "lscr.io/linuxserver/radarr:latest";
     environment = {
       TZ = "America/Chicago";
       PUID = "1000";
       PGID = "100";
     };
     ports = [ "7879:7878" ];
     volumes = [
       "/configs/radarr_mom:/config"
       "/storage/downloads:/downloads"
       "/storage/pool/media/watch/mom:/mom"
     ];
   };  
  };
}
