{ ... }:
{
  systemd.tmpfiles.rules = [
    "d /configs/requestrr 0755 justinlime justinlime -" #The - disables automatic cleanup, so the file wont be removed after a period
  ];
  virtualisation.oci-containers.containers = {
    requestrr = {
     autoStart = true; 
     image = "darkalfx/requestrr:latest";
     ports = [ "4545:4545" ];
     volumes = [
       "/configs/requestrr:/root/config"
     ];
   };  
  };
}
