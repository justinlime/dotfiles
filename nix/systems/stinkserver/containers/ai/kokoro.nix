{ ... }:
{
  # virtualisation.oci-containers.containers = {
  #   kokoro = {
  #    autoStart = true; 
  #    image = "ghcr.io/remsky/kokoro-fastapi-gpu:latest";
  #    # image = "ghcr.io/remsky/kokoro-fastapi-cpu:latest";
  #    ports = [ "8880:8880" ];
  #    extraOptions = [ "--device=nvidia.com/gpu=all" ];
  #    dependsOn = [ "vllm" ];
  #  };  
  # };
}
