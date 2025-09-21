{ ... }:
{
  # make shares visible for windows 10 clients 
  services.samba-wsdd = {
    openFirewall = true;
    enable = true; 
  };
  services.samba = {
    enable = true;
    openFirewall = true;
    settings = {
      global = {
        workgroup = "WORKGROUP";
        "server string" = "stinkserver";
        "netbios name" = "stinkserver";
        security = "user";
        "guest account" = "nobody";
        "map to guest" = "bad user";
        "unix extensions" = "no";
      };
      storage = {
        path = "/storage";
        browseable = "yes";
        "read only" = "no";
        "writeable" = "yes";
        "guest ok" = "no";
        "create mask" = "0644";
        "directory mask" = "0755";
        "valid users" = "justinlime";
        "follow symlinks" = "yes";
        "wide links" = "yes";
      };
    };
  };
}
