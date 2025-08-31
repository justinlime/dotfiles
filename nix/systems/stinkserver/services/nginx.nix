{ inputs, config, pkgs, ... }:
{
  networking.firewall.allowedTCPPorts = [ 90 ];
  security.acme = {
    acceptTerms = true;
    defaults.email = "foo@bar.com";
  };
  systemd.services.fileserver = {
    description="FileServer";
    serviceConfig = {
      User=config.sysMods.system.username;
      Group=config.sysMods.system.username;
      Restart="always";
      RestartSec="10s";
      LimitNOFILE=4096;
      ExecStart="${inputs.fileserver.packages.${pkgs.system}.default}/bin/go-fileserver --port 6900 --dir /storage/fileshare --debug";
    };
    wantedBy = [ "default.target" ];
  };
  services.nginx = {
    enable = true;
    virtualHosts = {
      # Give a 404 on unknown subdomains
      "unknown" = {
        serverName = "*.justinlime.dev *.stinkboys.com *.refundvalidator.com";
        listen = [{
          port = 90;
          addr = "0.0.0.0";
        }];
         locations."/" = {
           extraConfig = ''
             return 404;
           '';
         };
      };
      "justinlime.dev" = {
        # serverName = "justinlime.dev test.justinlime.dev";
        serverName = "justinlime.dev";
        root = "/sites/justinlime.dev/src/public";
        listen = [{
          port = 90;
          addr = "0.0.0.0";
        }];
         locations."/" = {
           extraConfig = ''
            index index.html;
           '';
         };
      };
      "cheatsheet.justinlime.dev" = {
        serverName = "cheatsheet.justinlime.dev";
        root = "/sites/cheatsheet/src/public";
        listen = [{
          port = 90;
          addr = "0.0.0.0";
        }];
         locations."/" = {
           extraConfig = ''
            index index.html;
           '';
         };
      };
      "test.justinlime.dev" = {
        serverName = "test.justinlime.dev";
        listen = [{
          port = 90;
          addr = "0.0.0.0";
        }];
        locations."/" = {
          proxyPass = "http://localhost:6969";
          extraConfig = ''
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;    
          '';
        };
      };
      "download.justinlime.dev" = {
        serverName = "downloads.justinlime.dev download.justinlime.dev stinkboys.com downloads.stinkboys.com download.stinkboys.com";
        listen = [{
          port = 90;
          addr = "0.0.0.0";
        }];
        locations."/" = {
          proxyPass = "http://localhost:6900";
          extraConfig = ''
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;    
          '';
        };
      };
    };
  };
}
