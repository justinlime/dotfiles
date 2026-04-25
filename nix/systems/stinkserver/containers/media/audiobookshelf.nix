{ ... }:
{
  systemd.tmpfiles.rules = [
    "d /configs/audiobookshelf 0755 justinlime justinlime -" #The - disables automatic cleanup, so the file wont be removed after a period
  ];
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
       "/configs/audiobookshelf:/config"
       "/configs/audiobookshelf:/metadata"
       "/storage/pool/media/listen:/listen"
    ];
    };  
  };
}
