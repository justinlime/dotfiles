{ ... }:
{
  systemd.tmpfiles.rules = [
    "d /configs/requestrr_mom 0755 justinlime justinlime -" #The - disables automatic cleanup, so the file wont be removed after a period
  ];
  virtualisation.oci-containers.containers = {
    requestrr_mom = {
     autoStart = true; 
     image = "darkalfx/requestrr";
     ports = [ "4546:4545" ];
     volumes = [
       "/configs/requestrr_mom:/root/config"
     ];
   };  
  };
}
