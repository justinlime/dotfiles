{ pkgs, ... }:
{
  systemd.tmpfiles.rules = [
    "d /configs/parakeet 0755 justinlime justinlime -" #The - disables automatic cleanup, so the file wont be removed after a period
    "d /configs/parakeet/data 0755 justinlime justinlime -" #The - disables automatic cleanup, so the file wont be removed after a period
  ];
  virtualisation.oci-containers.containers = {
    parakeet = {
     autoStart = true; 
     # GPU
     # image = "ghcr.io/tboby/wyoming-onnx-asr-gpu";
     image = "ghcr.io/tboby/wyoming-onnx-asr";
     ports = [ "10300:10300" ];
     volumes = [
       "/configs/parakeet/data:/data"
     ];
     # extraOptions = [ "--device=nvidia.com/gpu=all" ];
     # dependsOn = [ "vllm" ];
   };  
  };
}
