{ ... }:
{
  systemd.tmpfiles.rules = [
    "d /configs/komga 0755 justinlime justinlime -" #The - disables automatic cleanup, so the file wont be removed after a period
  ];
  virtualisation.oci-containers.containers = {
    komga = {
     autoStart = true; 
     image = "gotson/komga:latest";
     ports = [ "25600:25600" ];
     networks = [ "network" ];
     volumes = [
       "/configs/komga/config:/config"
       "/configs/komga/data:/data"
       "/storage/pool/media/read:/read"
     ];
   };  
  };
}
