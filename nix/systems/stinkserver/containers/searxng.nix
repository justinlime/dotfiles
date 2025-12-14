{ ... }:
{
  systemd.tmpfiles.rules = [
    "d /configs/searxng/data 0755 justinlime justinlime -" #The - disables automatic cleanup, so the file wont be removed after a period
    "d /configs/searxng/config 0755 justinlime justinlime -" #The - disables automatic cleanup, so the file wont be removed after a period
  ];
  virtualisation.oci-containers.containers = {
    searxng = {
     autoStart = true; 
     image = "docker.io/searxng/searxng:latest";
     ports = [ "8181:8080" ];
     networks = [ "network" ];
     volumes = [
       "/configs/searxng/data:/var/cache/searxng"
       "/configs/searxng/config:/etc/searxng"
     ];
   };  
  };
}
