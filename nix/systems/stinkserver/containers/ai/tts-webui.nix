{ ... }:
{
  # systemd.tmpfiles.rules = [
  #   "d /configs/tts-webui 0755 justinlime justinlime -" #The - disables automatic cleanup, so the file wont be removed after a period
  #   "d /configs/tts-webui/workspace 0755 justinlime justinlime -" #The - disables automatic cleanup, so the file wont be removed after a period
  # ];
  # virtualisation.oci-containers.containers = {
  #   tts-webui = {
  #    autoStart = true; 
  #    image = "ashleykza/tts-webui:latest";
  #    ports = [
  #      # TTS Webui
  #      "3000:3000" 
  #      # React TTS WebUI
  #      "3006:3006"
  #      # Code Server
  #      "7777:7777"
  #      # Application Manager 
  #      "8999:8000"
  #      # Jupyter Lab
  #      "8888:8888"
  #      # Runpod File Uploader
  #      "2999:2999"
  #      # OpenAI API
  #      "7778:7778"
  #    ];
  #    volumes = [
  #      "/configs/tts-webui/workspace:/workspace"
  #    ];
  #    environment = {
  #      VENV_PATH="/workspace/venvs/tts-webui";
  #    };
  #    extraOptions = [ "--device=nvidia.com/gpu=all" ];
  #    dependsOn = [ "vllm" ];
  #  };  
  # };
}
