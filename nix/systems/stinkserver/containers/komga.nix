{ ... }:
{
  virtualisation.oci-containers.containers = {
    komga = {
     autoStart = true; 
     image = "gotson/komga:latest";
     ports = [ "25600:25600" ];
     volumes = [
       "/configs/komga/config:/config"
       "/configs/komga/data:/data"
       "/storage/pool/media/read:/read"
     ];
   };  
  };
}
