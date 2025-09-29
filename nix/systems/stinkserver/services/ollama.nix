{ ... }:
{
  services.ollama = {
    enable = true;  
    openFirewall = true;
    acceleration = "cuda";
    host = "0.0.0.0";
  };
}
