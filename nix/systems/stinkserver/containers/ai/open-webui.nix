{ ... }:
{
  systemd.tmpfiles.rules = [
    "d /configs/open-webui 0755 justinlime justinlime -" #The - disables automatic cleanup, so the file wont be removed after a period
    "d /configs/open-webui/data 0755 justinlime justinlime -" #The - disables automatic cleanup, so the file wont be removed after a period
  ];
  virtualisation.oci-containers.containers = {
    open-webui = {
     autoStart = true; 
     image = "ghcr.io/open-webui/open-webui:main";
     ports = [ "4242:8080" ];
     networks = [ "network" ];
      environmentFiles = [
        "/configs/open-webui/open-webui.env"
      ];
     environment = {
       "USE_OLLAMA" = "false";
     };
     volumes = [
       "/configs/open-webui/data:/app/backend/data"
     ];
    };  
  };
}
