{ ... }:
{
  services.samba-wsdd.enable = true; # make shares visible for windows 10 clients
  services.samba.openFirewall = true;

  networking.firewall = {
    allowedTCPPorts = [
      5357 # wsdd
    ];
    allowedUDPPorts = [
      3702 # wsdd
    ];
  };
  services.samba = {
    enable = true;
    securityType = "user";
    extraConfig = ''
      workgroup = WORKGROUP
      server string = stinkserver
      netbios name = stinkserver
      security = user 
      guest account = nobody
      map to guest = bad user
      unix extensions = no
    '';
    shares = {
      storage = {
        path = "/storage";
        browseable = "yes";
        "read only" = "no";
        "writeable" = "yes";
        "guest ok" = "no";
        "create mask" = "0755";
        "directory mask" = "0755";
        "valid users" = "justinlime";
        "follow symlinks" = "yes";
        "wide links" = "yes";
      };
    };
  };
}
