{ ... }:
{
  systemd.tmpfiles.rules = [
    "d /configs/pihole/etc 0755 justinlime justinlime -" #The - disables automatic cleanup, so the file wont be removed after a period
    "d /configs/pihole/etc-dnsmasq.d 0755 justinlime justinlime -" #The - disables automatic cleanup, so the file wont be removed after a period
  ];
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
