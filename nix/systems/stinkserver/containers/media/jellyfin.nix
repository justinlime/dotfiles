{ ... }:
{
  networking.firewall.allowedTCPPorts = [ 8096 80 443 ];
  networking.firewall.allowedUDPPorts = [ 7359 1900 ];
  virtualisation.oci-containers.containers = {
    jellyfin = {
     autoStart = true; 
     image = "lscr.io/linuxserver/jellyfin:latest";
     environment = {
       TZ = "America/Chicago";
       PUID = "1000";
       PGID = "100";
     };
     ports = [ "8096:8096" "8920:8920" "1900:1900/udp" "7359:7359/udp" ];
     networks = [ "network" ];
     volumes = [
       "/containers/jellyfin:/config"
       "/storage/pool/media/watch/movies:/movies"
       "/storage/pool/media/watch/tv:/tv"
       "/storage/pool/media/watch/anime:/anime"
       "/storage/pool/media/watch:/watch"
       "/storage/pool/media/listen:/listen"
    ];
     extraOptions = [ "--device=/dev/dri/renderD128:/dev/dri/renderD128" ];
    };  
  };
}
