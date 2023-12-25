{ ... }:
{
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
