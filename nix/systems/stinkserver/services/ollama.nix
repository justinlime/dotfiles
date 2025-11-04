{ pkgs, lib, ... }:
{
  networking.firewall.allowedTCPPorts = [ 10300 ];
  services.ollama = {
    enable = true;  
    package = pkgs.ollama.overrideAttrs (_: rec {
      version = "0.12.7";
      src = pkgs.fetchFromGitHub {
        owner = "ollama";
        repo = "ollama";
        tag = "v${version}";
        hash = "sha256-IIkt0UOGo/HLrnZRgICDWgzLLW1VoYvW/SvgyWWlBCY=";
      };
    });
    openFirewall = true;
    acceleration = "cuda";
    host = "0.0.0.0";
  };
  # services.wyoming.faster-whisper.servers."stinkai" = {
  #   enable = true;  
  #   device = "cpu";
  #   model = "base.en";
  #   uri = "tcp://0.0.0.0:10300";
  #   language = "en";
  #   initialPrompt = "The following conversation takes place in the universe of\nWizard of Oz. Key terms include 'Yellow Brick Road' (the path\nto follow), 'Emerald City' (the ultimate goal), and 'Ruby\nSlippers' (the magical tools to succeed). Keep these in mind as\nthey guide the journey.\n";
  # };
}
