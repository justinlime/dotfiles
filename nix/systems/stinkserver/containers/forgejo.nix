{ ... }:
{
  virtualisation.oci-containers.containers = {
    forgejo = {
     autoStart = true; 
     image = "codeberg.org/forgejo/forgejo:15";
     environment = {
       USER_UID = "1000";
       USER_GID = "100";
       ROOT_URL = "https://git.justin-li.me:443";  
     };
     ports = [ "3000:3000" "222:22" ];
     networks = [ "network" ];
     volumes = [
       "/storage/pool/git/:/data/git"
       "/containers/forgejo/gitea:/data/gitea"
       "/containers/forgejo/ssh:/data/ssh"
       "/etc/localtime:/etc/localtime:ro"
     ];
    };  
  };
}
