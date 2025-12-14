{ pkgs, lib, ... }:
{
  systemd.tmpfiles.rules = [
    "d /configs/qbittorrentvpn 0755 justinlime justinlime -" #The - disables automatic cleanup, so the file wont be removed after a period
  ];
  # If the logs look correct, but the webgui is still not accessible, its probably a
  # LAN_NETWORK misconfiguration
  # Ensure paths for downloads is set correctly in qbittorrent itself 
  virtualisation.oci-containers.containers = {

    qbittorrentvpn = {
     autoStart = true; 
     image = "dyonr/qbittorrentvpn";
     environment = {
       TZ = "America/Chicago";
       PUID = "1000";
       PGID = "100";
       VPN_ENABLED = "yes";
       VPN_TYPE = "wireguard";
       WEBUI_PORT_ENV = "8080";
       INCOMING_PORT_ENV = "8999";
       NAME_SERVERS = "9.9.9.9,149.112.112.112";
       LAN_NETWORK = "10.69.42.0/24,192.168.69.0/24";
     };
     ports = [ "8080:8080" "57529:57529" "57529:57529/udp" ];
     networks = [ "network" ];
     volumes = [
       "/configs/qbittorrentvpn:/config"
       "/storage/downloads:/downloads"
     ];
     extraOptions = [ "--privileged" ];
    };  
  };
}
