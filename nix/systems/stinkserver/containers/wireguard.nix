{ hush, ... }:
{
  virtualisation.oci-containers.containers = {
    wireguard = {
     autoStart = true; 
     image = "lscr.io/linuxserver/wireguard:latest";
     environment = {
       TZ = "America/Chicago";
       PUID = "1000";
       PGID = "100";
       PEERS = "1";
       PEERDNS = "9.9.9.9";
       ALLOWEDIPS = "0.0.0.0/0";
       SERVERPORT = "51820";
       SERVERURL = "${hush.wireguard.stinkserver-url}";
     };
     ports = [ "51820:51820/udp" ];
     volumes = [
       "/configs/wireguard:/config"
     ];
     extraOptions = [ 
       "--cap-add=NET_ADMIN,NET_RAW"
       "--cap-add=SYS_MODULE"
       ''--sysctl="net.ipv4.conf.all.src_valid_mark=1"'' 
     ];
    };  
  };
}
