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
