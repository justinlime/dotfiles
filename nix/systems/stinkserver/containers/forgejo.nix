{ ... }:
{
  virtualisation.oci-containers.containers = {
    forgejo = {
     autoStart = true; 
     image = "codeberg.org/forgejo/forgejo:13";
     environment = {
       USER_UID = "1000";
       USER_GID = "100";
     };
     ports = [ "3000:3000" "222:22" ];
     networks = [ "network" ];
     volumes = [
       "/storage/pool/git:/data"
       "/etc/localtime:/etc/localtime:ro"
     ];
    };  
  };
  services.nginx = {
    enable = true;
    virtualHosts = {
      "git.justin-li.me" = {
        serverName = "git.justin-li.me";
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          recommendedProxySettings = true;
          proxyWebsockets = true;
          proxyPass = "http://127.0.0.1:3000";
        };
      };
    };
  };
}
