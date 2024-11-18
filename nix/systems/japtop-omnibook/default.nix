{ flake_path, ... }:
{
  imports = [ 
    ./hardware-configuration.nix 
    ../base/configuration.nix
    ../base/gaming.nix
    ../base/wayland.nix
    ../base/networking.nix
    ../base/virtulization.nix
    ../base/usb.nix
    ../base/avahi.nix
    ../base/docker.nix
  ];
  programs = {
    light.enable = true;
  };
  networking.hostName = "japtop";
  hardware.ledger.enable = true;
  services = {
    tlp.enable = true;
  };
  # Fix for the zenbook S16's speakers only using the tweeters
  services.pipewire.extraConfig.pipewire-pulse."99-speaker-routing" = {
    "context.modules" = [{
        name = "libpipewire-module-loopback";
        args = {
          "node.description" = "Stereo to 4.0 upmix";
          "audio.position" = [ "FL" "FR" ];
          "capture.props" = {
            "node.name" = "sink.upmix_4_0";
            "media.class" = "Audio/Sink";
          };
          "playback.props" = {
            "node.name" = "playback.upmix-4.0";
            "audio.position" = [ "FL" "FR" "RL" "RR" ];
            "target.object" = "alsa_output.pci-0000_c4_00.6.analog-surround-40";
            "stream.dont-remix" = "true";
            "node.passive" = "true";
            "channelmix.upmix" = "true";
            "channelmix.upmix-method" = "simple";
          };
        };
      }];
  };
}
