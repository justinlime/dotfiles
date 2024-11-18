{ ... }:
{
  systemd.tmpfiles.rules = [
    "d /configs/gitea 0755 justinlime justinlime -" #The - disables automatic cleanup, so the file wont be removed after a period
  ];
  virtualisation.oci-containers.containers = {
    gitea = {
     autoStart = true; 
     image = "gitea/gitea:1.21.11";
     environment = {
       USER_UID = "1000";
       USER_GID = "100";
     };
     ports = [ "3000:3000" "222:22" ];
     volumes = [
       "/storage/pool/git:/data"
       # "/etc/timezone:/etc/timezone:ro"
       "/etc/localtime:/etc/localtime:ro"
     ];
    };  
  };
  services.nginx = {
    enable = true;
    virtualHosts = {
      "git.justinlime.dev" = {
        listen = [{
          port = 90;
          addr = "0.0.0.0";
        }
        ];
        locations."/" = {
          proxyPass = "http://localhost:3000";
          extraConfig = ''
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
            proxy_set_header X-Forwarded-Protocol $scheme;
            proxy_set_header X-Forwarded-Host $http_host;
          '';
        };
      };
    };
  };
}
