{ pkgs, ... }:
{
  services = {
    mpdris2.enable = true;
    mpd = {
      enable = true;
      musicDirectory = "/home/justinlime/music";
      network.startWhenNeeded = true;  
      extraConfig = ''
        audio_output {
          type            "pipewire"
          name            "PipeWire Sound Server"
        }
      '';
    };
  };
  programs = {
    ncmpcpp = {
      enable = true;
      package = pkgs.ncmpcpp.override { visualizerSupport = true; };
    };
  };
}
