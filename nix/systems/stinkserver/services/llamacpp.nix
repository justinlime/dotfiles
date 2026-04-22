{ pkgs, inputs, ... }: {
  # services.llama-cpp = {
  #   enable = true;
  #   package = inputs.llamacpp.packages.${pkgs.stdenv.hostPlatform.system}.cuda;      
  #   host = "0.0.0.0";
  #   port = 8281;
  #   openFirewall = true;
  #   model = "/configs/llama-cpp/gemma-4-26B-A4B-it-UD-IQ4_XS.gguf";
  #   extraFlags = [
  #     "--alias" "StinkGPT"
  #     "--n-gpu-layers" "99"
  #     "--ctx-size" "400000"
  #     "--cont-batching"
  #     "--flash-attn" "on"
  #     "--cache-type-k" "turbo3"
  #     "--cache-type-v" "turbo3"
  #     "--parallel" "3"
  #     "--presence_penalty" "0.0"
  #     "--repeat_penalty" "1.0"
  #     "--temp" "1.0"
  #     "--top-p" "0.95"
  #     "--top-k" "64"
  #     "--min-p" "0.00"
  #   ];
  # };
}
