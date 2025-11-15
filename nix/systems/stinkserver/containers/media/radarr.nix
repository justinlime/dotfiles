{ ... }:
{
  systemd.tmpfiles.rules = [
    "d /configs/radarr 0755 justinlime justinlime -" #The - disables automatic cleanup, so the file wont be removed after a period
  ];
  virtualisation.oci-containers.containers = {
    radarr = {
     autoStart = true; 
     image = "lscr.io/linuxserver/radarr:latest";
     environment = {
       TZ = "America/Chicago";
       PUID = "1000";
       PGID = "100";
     };
     ports = [ "7878:7878" ];
     volumes = [
       "/configs/radarr:/config"
       "/storage/downloads:/downloads"
       "/storage/pool/media/watch/movies:/movies"
     ];
   };  
  };
}
