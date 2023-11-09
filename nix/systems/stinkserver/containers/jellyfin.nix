{ ... }:
{
  virtualisation.oci-containers.containers = {
    jellyfin = {
     autoStart = true; 
     image = "lscr.io/linuxserver/jellyfin:latest";
     environment = {
       TZ = "America/Chicago";
       PUID = "1000";
       PGID = "100";
     };
     ports = [ "8096:8096" "8920:8920" ];
     volumes = [
       "/configs/jellyfin:/config"
       "/storage/pool/media/watch/movies:/movies"
       "/storage/pool/media/watch/tv:/tv"
       "/storage/pool/media/watch/anime:/anime"
     ];
     extraOptions = [ "--device=/dev/dri/renderD128:/dev/dri/renderD128" "--device=/dev/dri/card0:/dev/dri/card0" ];
    };  
  };
}
