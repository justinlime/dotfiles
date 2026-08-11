{ ... }:
{
  virtualisation.oci-containers.containers = {
    searxng = {
     autoStart = true; 
     image = "docker.io/searxng/searxng:latest";
     ports = [ "8181:8080" ];
     networks = [ "network" ];
     volumes = [
       "/containers/searxng/data:/var/cache/searxng"
       "/containers/searxng/config:/etc/searxng"
     ];
   };  
  };
}
