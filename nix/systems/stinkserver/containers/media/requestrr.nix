{ ... }:
{
  systemd.tmpfiles.rules = [
    "d /configs/requestrr 0755 justinlime justinlime -" #The - disables automatic cleanup, so the file wont be removed after a period
  ];
  virtualisation.oci-containers.containers = {
    requestrr = {
     autoStart = true; 
     image = "ghcr.io/hotio/requestrr";
     environment = {
       TZ = "America/Chicago";
       PUID = "1000";
       PGID = "100";
     };
     ports = [ "4545:4545" ];
     volumes = [
       "/configs/requestrr:/config"
     ];
   };  
  };
}
