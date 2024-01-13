{ ... }:
{
  systemd.tmpfiles.rules = [
    "d /configs/nzbget 0755 justinlime justinlime -" #The - disables automatic cleanup, so the file wont be removed after a period
  ];
  virtualisation.oci-containers.containers = {
    nzbget = {
     autoStart = true; 
     image = "lscr.io/linuxserver/nzbget:latest";
     environment = {
       TZ = "America/Chicago";
       PUID = "1000";
       PGID = "100";
     };
     ports = [ "6789:6789" ];
     volumes = [
       "/configs/nzbget:/config"
       "/storage/pool/downloads:/downloads"
     ];
   };  
  };
}
