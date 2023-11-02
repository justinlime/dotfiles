{ ... }:
{
  services.samba-wsdd.enable = true; # make shares visible for windows 10 clients
  services.samba.openFirewall = true;

  networking.firewall.allowedTCPPorts = [
    5357 # wsdd
  ];
  networking.firewall.allowedUDPPorts = [
    3702 # wsdd
  ];
  services.samba = {
    enable = true;
    securityType = "user";
    extraConfig = ''
      workgroup = WORKGROUP
      server string = stinkserver
      netbios name = stinkserver
      security = user 
      hosts allow = 192.168. 127.0.0.1 localhost
      hosts deny = 0.0.0.0/0
      guest account = nobody
      map to guest = bad user
    '';
    shares = {
      fileshare = {
        path = "/drives/NVME0/fileshare";
        browseable = "yes";
        "read only" = "no";
        "writeable" = "yes";
        "guest ok" = "yes";
        "create mask" = "0755";
        "directory mask" = "0755";
        #"force user" = "username";
        #"force group" = "groupname";
      };
      users = {
        path = "/drives/NVME0/users";
        browseable = "yes";
        "read only" = "no";
        "writeable" = "yes";
        "guest ok" = "yes";
        "create mask" = "0755";
        "directory mask" = "0755";
        #"force user" = "username";
        #"force group" = "groupname";
      };
    };
  };
}
