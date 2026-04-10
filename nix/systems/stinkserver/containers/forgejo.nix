{ ... }:
{
  virtualisation.oci-containers.containers = {
    forgejo = {
     autoStart = true; 
     image = "codeberg.org/forgejo/forgejo:13";
     environment = {
       USER_UID = "1000";
       USER_GID = "100";
       ROOT_URL = "https://git.justin-li.me:443";  
     };
     ports = [ "3000:3000" "222:22" ];
     networks = [ "network" ];
     volumes = [
       "/storage/pool/git:/data"
       "/etc/localtime:/etc/localtime:ro"
     ];
    };  
  };
}
