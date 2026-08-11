{ pkgs, ... }:
{
  virtualisation.oci-containers.containers = {
    parakeet = {
     autoStart = true; 
     # GPU
     # image = "ghcr.io/tboby/wyoming-onnx-asr-gpu";
     image = "ghcr.io/tboby/wyoming-onnx-asr";
     ports = [ "10300:10300" ];
     networks = [ "network" ];
     volumes = [
       "/containers/parakeet/data:/data"
     ];
     # extraOptions = [ "--device=nvidia.com/gpu=all" ];
     # dependsOn = [ "vllm" ];
   };  
  };
}
