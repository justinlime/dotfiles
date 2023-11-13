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
      "downloads.stinkboys.com" = {
        serverName = "downloads.stinkboys.com";
        listen = [{
          port = 90;
          addr = "0.0.0.0";
        }];
        locations."/" = {
          root = "/drives/NVME0/fileshare";
          extraConfig = ''
            autoindex on;
          '';
        };
      };
      # "watch.stinkboys.com" = {
      #   listen = [{
      #     port = 90;
      #     addr = "0.0.0.0";
      #   }];  
      #   locations."/" = {
      #     proxyPass = "http://127.0.0.1:8096/";
      #     extraConfig = ''
      #       proxy_set_header Host $host;
      #       proxy_set_header X-Real-IP $remote_addr;
      #       proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;    
      #       proxy_set_header X-Forwarded-Proto $scheme;
      #     '';
      #   };
      # };
    };
  };
}
