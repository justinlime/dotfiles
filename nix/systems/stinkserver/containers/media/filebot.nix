{ ... }:
{
  systemd.tmpfiles.rules = [
    "d /configs/filebot 0755 justinlime justinlime -" #The - disables automatic cleanup, so the file wont be removed after a period
  ];
  virtualisation.oci-containers.containers = {
    filebot = {
     autoStart = true; 
     image = "jlesage/filebot";
     ports = [ "5800:5800" ];
     volumes = [
       "/configs/filebot:/config"
       "/storage/pool:/storage"
     ];
   };  
  };
}
