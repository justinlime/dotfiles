{ ... }:
{
  virtualisation.oci-containers.containers = {
    komga = {
     autoStart = true; 
     image = "gotson/komga:latest";
     ports = [ "25600:25600" ];
     networks = [ "network" ];
     volumes = [
       "/containers/komga/config:/config"
       "/containers/komga/data:/data"
       "/storage/pool/media/read:/read"
     ];
   };  
  };
}
