{ ... }:
{
  virtualisation.oci-containers.containers = {
    ntfy = {
      autoStart = true;
      image = "binwiederhier/ntfy:latest";
      ports = [
        "8043:80"
      ];
      networks = [
        "network"
      ];
      volumes = [
        "/configs/ntfy/cache:/var/cache/ntfy"
        "/configs/ntfy/db:/var/lib/ntfy"
        "/configs/ntfy/server.yml:/etc/ntfy/server.yml"
      ];
      cmd = [ "serve" ];
    };
  };
}
