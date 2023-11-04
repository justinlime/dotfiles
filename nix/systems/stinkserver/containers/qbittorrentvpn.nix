{ ... }:
{
  # If the logs look correct, but the webgui is still not accessible, its probably a
  # LAN_NETWORK misconfiguration
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
       LAN_NETWORK = "192.168.0.0/16";
     };
     ports = [ "8080:8080" "8999:8999" "8999:8999/udp" ];
     volumes = [
       "/configs/qbittorrentvpn:/config"
       "/storage/pool/downloads:/downloads"
     ];
     extraOptions = [
       "--privileged"
     ];
    };  
  };
}
