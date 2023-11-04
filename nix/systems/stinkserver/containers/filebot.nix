{ ... }:
{
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
