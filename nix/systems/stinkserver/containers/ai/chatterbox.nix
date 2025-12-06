{ ... }:
{
  # systemd.tmpfiles.rules = [
  #   "d /configs/tts-webui 0755 justinlime justinlime -" #The - disables automatic cleanup, so the file wont be removed after a period
  #   "d /configs/tts-webui/data 0755 justinlime justinlime -" #The - disables automatic cleanup, so the file wont be removed after a period
  #   "d /configs/tts-webui/outputs 0755 justinlime justinlime -" #The - disables automatic cleanup, so the file wont be removed after a period
  #   "d /configs/tts-webui/favorites 0755 justinlime justinlime -" #The - disables automatic cleanup, so the file wont be removed after a period
  # ];
  # virtualisation.oci-containers.containers = {
  #   tts-webui = {
  #    autoStart = true; 
  #    image = "ghcr.io/rsxdalv/tts-webui:main";
  #    ports = [ "7770:7770" "3330:3000" "7778:7778" ];
  #    volumes = [
  #      "/configs/tts-webui/data:/app/tts-webui/data"
  #      "/configs/tts-webui/outputs:/app/tts-webui/outputs"
  #      "/configs/tts-webui/favorites:/app/tts-webui/favorites"
  #    ];
  #    extraOptions = [ "--device=nvidia.com/gpu=all" ];
  #    # dependsOn = [ "vllm" ];
  #  };  
  # };
}
