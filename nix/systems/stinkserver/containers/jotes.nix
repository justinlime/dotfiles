{ ... }:
{
  # systemd.tmpfiles.rules = [
  #   "d /containers/jotes 0755 justinlime justinlime -" #The - disables automatic cleanup, so the file wont be removed after a period
  # ];
  # virtualisation.oci-containers.containers = {
  #   jotes = {
  #    autoStart = true; 
  #    image = "docker.io/justinlime/jotes:latest";
  #    ports = [ ];
  #    networks = [ "network" ];
  #    volumes = [
  #      "/containers/portainer:/data"
  #      "/run/podman/podman.sock:/var/run/docker.sock"
  #    ];
  #   };  
  # };
}
