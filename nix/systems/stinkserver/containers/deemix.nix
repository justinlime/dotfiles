{ ... }:
{
  virtualisation.oci-containers.containers = {
    deemix = {
     autoStart = true; 
     image = "registry.gitlab.com/bockiii/deemix-docker";
     environment = {
       TZ = "America/Chicago";
       PUID = "1000";
       PGID = "100";
       UMASK_SET="022";
       DEEMIX_SINGLE_USER="true";
     };
     ports = [ "6595:6595" ];
     volumes = [
       "/configs/deemix:/config"
       "/storage/downloads/deemix:/downloads"
     ];
    };  
  };
}
