{ pkgs, ... }:
{
  systemd.tmpfiles.rules = [
    "d /configs/whisper 0755 justinlime justinlime -" #The - disables automatic cleanup, so the file wont be removed after a period
    "d /configs/whisper/config 0755 justinlime justinlime -" #The - disables automatic cleanup, so the file wont be removed after a period
  ];
  virtualisation.oci-containers.containers = {
    whisper = {
     autoStart = true; 
     # GPU
     image = " lscr.io/linuxserver/faster-whisper:gpu";
     ports = [ "10300:10300" ];
     volumes = [
       "/configs/whisper/config:/config"
     ];
     environment = {
       "PUID" = "1000";
       "PGID" = "100";
       "TZ" = "America/Chicago";
       "WHISPER_MODEL" = "large-v3-turbo";
       "WHISPER_LANG" = "en";
     };
     # GPU 
     extraOptions = [ "--device=nvidia.com/gpu=all" ];
   };  
  };
}
