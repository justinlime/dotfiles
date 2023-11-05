{ ... }:
{
  virtualisation.oci-containers.containers = {
    requestrr = {
     autoStart = true; 
     image = "darkalfx/requestrr";
     ports = [ "4545:4545" ];
     volumes = [
       "/configs/requestrr:/root/config"
     ];
   };  
  };
}
