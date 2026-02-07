{ ... }:
{
  systemd.tmpfiles.rules = [
    "d /configs/fatterbox 0755 justinlime justinlime -" #The - disables automatic cleanup, so the file wont be removed after a period
    # "d /configs/fatterbox/venv 0755 justinlime justinlime -" #The - disables automatic cleanup, so the file wont be removed after a period
    "d /configs/fatterbox/voices 0755 justinlime justinlime -" #The - disables automatic cleanup, so the file wont be removed after a period
  ];
  virtualisation.oci-containers.containers = {
    fatterbox = {
     autoStart = true; 
     image = "docker.io/justinlime/fatterbox:v0.1.0";
     ports = [
       "5002:8000"
       "10200:10200"
     ];
     networks = [ "network" ];
     environment = {
       FATTERBOX_DEVICE = "cuda";
       FATTERBOX_DTYPE = "bf16";
       FATTERBOX_CFG_WEIGHT = "1.0";
       FATTERBOX_EXAGGERATION = "0.5";
       FATTERBOX_TEMPERATURE = "0.8";
     };
     volumes = [
       "/configs/fatterbox/voices:/chatter/voices"
     ];
     extraOptions = [ "--device=nvidia.com/gpu=all" ];
     dependsOn = [ "vllm" ];
   };  
  };
}
