{ ... }:
{
  systemd.tmpfiles.rules = [
    "d /configs/fatterbox 0755 justinlime justinlime -" #The - disables automatic cleanup, so the file wont be removed after a period
    "d /configs/fatterbox/venv 0755 justinlime justinlime -" #The - disables automatic cleanup, so the file wont be removed after a period
    "d /configs/fatterbox/voices 0755 justinlime justinlime -" #The - disables automatic cleanup, so the file wont be removed after a period
  ];
  virtualisation.oci-containers.containers = {
    fatterbox = {
     autoStart = true; 
     image = "docker.io/justinlime/fatterbox";
     ports = [
       "5002:5002"
       "10200:10200"
     ];
     environment = {
       DEVICE = "cuda";
       DYTYPE = "float16";
       STREAMING = "true";
       VOICES_DIR = "/voices";
       
     };
     volumes = [
       "/configs/fatterbox/voices:/voices"
     ];
     extraOptions = [ "--device=nvidia.com/gpu=all" ];
     dependsOn = [ "vllm" ];
   };  
  };
}
