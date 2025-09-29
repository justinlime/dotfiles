{ ... }:
{
  systemd.tmpfiles.rules = [
    "d /configs/portainer 0755 justinlime justinlime -" #The - disables automatic cleanup, so the file wont be removed after a period
  ];
  virtualisation.oci-containers.containers = {
    portainer = {
     autoStart = true; 
     image = "portainer/portainer-ce:latest";
     ports = [ "9000:9000" "8000:8000" "9443:9443" ];
     volumes = [
       "/configs/portainer:/data"
       "/run/podman/podman.sock:/var/run/docker.sock"
     ];
    };  
  };
}
