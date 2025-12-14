{ ... }:
{
  systemd.tmpfiles.rules = [
    "d /configs/plex 0755 justinlime justinlime -" #The - disables automatic cleanup, so the file wont be removed after a period
  ];
  virtualisation.oci-containers.containers = {
    plex = {
     autoStart = true; 
     image = "lscr.io/linuxserver/plex:latest";
     environment = {
       TZ = "America/Chicago";
       PUID = "1000";
       PGID = "100";
     };
     ports = [ "32400:32400" ];
     networks = [ "network" ];
     volumes = [
       "/configs/plex:/config"
       "/storage/pool/media/watch/movies:/movies"
       "/storage/pool/media/watch/tv:/tv"
       "/storage/pool/media/watch/anime:/anime"
     ];
     extraOptions = [ "--device=/dev/dri:/dev/dri" ];
    };  
  };
}
