{ ... }:
{
  virtualisation.oci-containers.containers = {
    open-webui = {
     autoStart = true; 
     image = "ghcr.io/open-webui/open-webui:main";
     ports = [ "4242:8080" ];
     networks = [ "network" ];
      environmentFiles = [
        "/containers/open-webui/open-webui.env"
      ];
     environment = {
       "USE_OLLAMA" = "false";
     };
     volumes = [
       "/containers/open-webui/data:/app/backend/data"
     ];
    };  
  };
}
