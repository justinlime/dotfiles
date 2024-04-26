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
      "justinlime.dev" = {
        serverName = "justinlime.dev test.justinlime.dev";
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
        serverName = "downloads.stinkboys.com download.stinkboys.com";
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
