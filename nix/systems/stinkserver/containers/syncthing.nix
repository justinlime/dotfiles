{ ... }:
{
  systemd.tmpfiles.rules = [
    "d /configs/syncthing 0755 justinlime justinlime -" #The - disables automatic cleanup, so the file wont be removed after a period
  ];
  virtualisation.oci-containers.containers = {
    syncthing = {
     autoStart = true; 
     image = "lscr.io/linuxserver/syncthing:latest";
     environment = {
       TZ = "America/Chicago";
       PUID = "1000";
       PGID = "100";
     };
     ports = [
       "8384:8384"
       "22000:22000/tcp"
       "22000:22000/udp"
       "21027:21027/udp"
     ];
     volumes = [
       "/configs/syncthing:/config"
       "/storage/users/justin:/data1"
     ];
     extraOptions = [ 
       "--hostname=stinkserver-syncthing"
       "--name=stinkserver-syncthing"
     ];
    };  
  };
}
