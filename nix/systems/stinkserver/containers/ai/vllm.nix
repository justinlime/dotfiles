{ lib, pkgs, ... }:
{
  systemd.tmpfiles.rules = [
    "d /configs/vllm 0755 justinlime justinlime -" #The - disables automatic cleanup, so the file wont be removed after a period
  ];
  virtualisation.oci-containers.containers = {
    vllm = {
     autoStart = true; 
     image = "vllm/vllm-openai:latest";
     ports = [ "8282:8000" ];
     volumes = [
       "/configs/vllm:/root/.cache/huggingface"
     ];
     podman.sdnotify = "healthy";
     cmd = [
       # "--tool-call-parser=hermes"
       # "--model=QuantTrio/Qwen3-VL-30B-A3B-Instruct-AWQ"
       # "--enable-auto-tool-choice"
       # "--gpu-memory-utilization=0.945"
       # "--max-model-len=22400"
       # "--dtype=float16"

       "--tool-call-parser=hermes"
       # "--model=huihui-ai/Huihui-Qwen3-VL-30B-A3B-Instruct-abliterated"
       "--model=QuantTrio/Qwen3-VL-30B-A3B-Instruct-AWQ"
       "--enable-auto-tool-choice"
       "--served-model-name=StinkGPT"
       "--gpu-memory-utilization=0.90"
       "--max-model-len=12000"
       "--max-num-seqs=8"
     ];
     extraOptions = [
       "--ipc=host"
       "--device=nvidia.com/gpu=all"
       "--health-cmd=curl -f http://10.69.42.200:8282/health"
       "--health-retries=10"
       "--health-interval=30s"
       "--health-start-period=240s"
     ];
   };  
  };
}
