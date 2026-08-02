{ ... }:
{
  virtualisation.oci-containers.containers = {
    splash = {
     autoStart = true; 
     image = "docker.io/justinlime/splash:latest";
     ports = [ "8087:8087" ];
     networks = [ "network" ];
    };  
  };
}
