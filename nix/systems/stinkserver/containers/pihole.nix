{ ... }:
{
  virtualisation.oci-containers.containers = {
    pihole = {
     autoStart = true; 
     image = "pihole/pihole:latest";
     environment = {
       TZ = "America/Chicago";
     };
     ports = [ "53:53" "53:53/udp" "89:80" ];
     volumes = [
       "/configs/pihole/etc:/etc/pihole"
       "/configs/pihole/etc-dnsmasq.d:/etc/dnsmasq.d"
     ];
     extraOptions = [ "--cap-add=NET_ADMIN" ];
    };  
  };
}
