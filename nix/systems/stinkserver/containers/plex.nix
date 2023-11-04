{ ... }:
{
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
