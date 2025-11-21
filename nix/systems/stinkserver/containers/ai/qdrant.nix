{ ... }:
{
  systemd.tmpfiles.rules = [
    "d /configs/qdrant 0755 justinlime justinlime -" #The - disables automatic cleanup, so the file wont be removed after a period
  ];
  virtualisation.oci-containers.containers = {
    qdrant = {
     autoStart = true; 
     image = "qdrant/qdrant";
     ports = [ "6333:6333" "6334:6334" ];
     volumes = [ "/configs/qdrant:/qdrant/storage" ];
   };  
  };
}
