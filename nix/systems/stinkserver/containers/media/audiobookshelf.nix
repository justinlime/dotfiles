{ ... }:
{
  virtualisation.oci-containers.containers = {
    audiobookshelf = {
     autoStart = true; 
     image = "advplyr/audiobookshelf:latest";
     environment = {
       TZ = "America/Chicago";
       PUID = "1000";
       PGID = "100";
     };
     ports = [ "1337:80" ];
     networks = [ "network" ];
     volumes = [
       "/containers/audiobookshelf:/config"
       "/containers/audiobookshelf:/metadata"
       "/storage/pool/media/listen:/listen"
    ];
    };  
  };
}
