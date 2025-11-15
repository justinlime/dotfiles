{ ... }:
{
  systemd.tmpfiles.rules = [
    "d /configs/cleanuparr 0755 justinlime justinlime -" #The - disables automatic cleanup, so the file wont be removed after a period
  ];
  virtualisation.oci-containers.containers = {
    cleanuparr = {
     autoStart = true; 
     image = "ghcr.io/cleanuparr/cleanuparr:latest";
     environment = {
       TZ = "America/Chicago";
       PUID = "1000";
       PGID = "100";
     };
     ports = [ "11011:11011" ];
     volumes = [
       "/configs/cleanuparr:/config"
     ];
   };  
  };
}
