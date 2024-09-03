{ ... }:
{
  networking.firewall.allowedTCPPorts = [ 90 ];
  security.acme = {
    acceptTerms = true;
    defaults.email = "justinlime1999@gmail.com";
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
        serverName = "downloads.justinlime.dev download.justinlime.dev";
        listen = [{
          port = 90;
          addr = "0.0.0.0";
        }];
        locations."/" = {
          root = "/drives/NVME0/fileshare";
          extraConfig = ''
            add_before_body /.theme/header.html;
            add_after_body /.theme/footer.html;
            autoindex on;
            autoindex_exact_size off;
          '';
        };
      };
      "downloads.stinkboys.com" = {
        serverName = "stinkboys.com downloads.stinkboys.com download.stinkboys.com";
        listen = [{
          port = 90;
          addr = "0.0.0.0";
        }];
        locations."/" = {
          root = "/drives/NVME0/fileshare";
          extraConfig = ''
            add_before_body /.theme/header.html;
            add_after_body /.theme/footer.html;
            autoindex on;
            autoindex_exact_size off;
          '';
        };
      };
    };
  };
}
