{ ... }:
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
     cmd = [
       "--tool-call-parser=hermes"
       "--enable-auto-tool-choice"
       "--swap-space=8"
       "--model=QuantTrio/Qwen3-VL-30B-A3B-Instruct-AWQ"
       # "--model=huihui-ai/Huihui-Qwen3-VL-30B-A3B-Instruct-abliterated"
       "--gpu-memory-utilization=0.92"
       "--max-model-len=12000" ];
     extraOptions = [ "--ipc=host" "--device=nvidia.com/gpu=all" ];
   };  
  };
}
