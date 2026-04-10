{ lib, pkgs, ... }:
{
  # systemd.tmpfiles.rules = [
  #   "d /configs/llama-cpp 0755 justinlime justinlime -"
  # ];
  # virtualisation.oci-containers.containers = {
  #   llama-cpp = {
  #     autoStart = true;
  #     image = "ghcr.io/ggml-org/llama.cpp:server-cuda"; 
  #     ports = [ "8281:8080" ];
  #     networks = [ "network" ];
  #     volumes = [
  #       "/configs/llama-cpp:/root/.cache/llama.cpp"
  #     ];
  #     podman.sdnotify = "healthy";
  #     cmd = [
  #       # "-hf" "Jackrong/Qwen3.5-27B-Claude-4.6-Opus-Reasoning-Distilled-GGUF:Q4_K_M"
  #       # "-hf" "mradermacher/Qwen3.5-27B-Claude-4.6-Opus-Reasoning-Distilled-i1-GGUF:IQ4_XS"
  #       # "-hf" "bartowski/Qwen_Qwen3.5-35B-A3B-GGUF:IQ4_XS"
  #       # "-hf" "unsloth/Qwen3.5-122B-A10B-GGUF:UD-IQ2_XXS"
  #       # "-hf" "bartowski/Qwen_Qwen3.5-27B-GGUF:Q4_K_M"
  #       # "-hf" "bartowski/Qwen_Qwen3.5-27B-GGUF:IQ4_XS"
  #       # "--fit" "on"
  #       # "-hf" "unsloth/Qwen3.5-27B-GGUF:UD-Q4_K_XL"
  #       "-m" "/root/.cache/llama.cpp/Qwen3.5-27B-Claude-4.6-Opus-Reasoning-Distilled.i1-IQ4_XS.gguf"
  # 
  #       
  #       "--alias" "StinkGPT"
  #       "--host" "0.0.0.0"
  #       "--port" "8080"
  #       "--n-gpu-layers" "99"
  #       # Lower = more VRAM vs RAM
  #       "--ctx-size" "160000"
  #       # "--parallel" "2"
  #       "--cont-batching"
  #       "--flash-attn" "on"
  #       # Disable vision for extra VRAM
  #       # "--no-mmproj"
  #       # MOE models only, offload some layers to system mem
  #       # "--n-cpu-moe" "8"
  #       "--cache-type-k" "q8_0"
  #       "--cache-type-v" "q8_0"
  #       # "--cache-type-k" "bf16"
  #       # "--cache-type-v" "bf16"
  #       "--presence_penalty" "0.0"
  #       "--repeat_penalty" "1.1"
  #       # "--jinja"
  #       "--temp" "0.6"
  #       "--top-p" "0.95"
  #       "--top-k" "20"
  #       "--min-p" "0.00"
  #       # "--chat-template-kwargs" "{ \"enable_thinking\": false }"
  #       # "--reasoning-budget" "0"
  #     ];
  #     environment = {
  #       HUGGING_FACE_HUB_TOKEN = ""; # fill in if needed
  #     };
  #     extraOptions = [
  #       "--ipc=host"
  #       "--device=nvidia.com/gpu=all"
  #       "--health-cmd=curl -f http://10.69.42.200:8281/health"
  #       "--health-retries=10"
  #       "--health-interval=30s"
  #       "--health-start-period=300s"
  #     ];
  #   };
  # };
}
