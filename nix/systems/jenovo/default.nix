{ pkgs, ... }:
let
  # Fix sound
  conf = pkgs.fetchFromGitHub {
    owner = "alsa-project"; 
    repo = "alsa-ucm-conf";
    rev = "c3314b9ca29861d19164d2b3987745b7170dab06";
    hash = "sha256-e5QEd2sOQosr8xumGEanrh+KY3k09ZGqvylkKqriqlk=";
  };
in
{
  imports = [ 
    ./hardware-configuration.nix 
  ];
  environment.sessionVariables.ALSA_CONFIG_UCM2 = "${conf}/ucm2";
  sysMods = {
    system = rec {
      username = "justinlime";  
      flakeDirectory = "/home/${username}/dotfiles";
    }; 
    usbautomount.enable = true;
    wayland.enable = true;
    virt.enable = true;
    firewall = {
      enable = true;  
      BothPorts = [ 1313 6969 1317 ];
    };
  };
  services.logind.extraConfig = ''
    HandlePowerKey=ignore
  '';
  programs = {
    light.enable = true;
  };
  networking.hostName = "jenovo";
  hardware.ledger.enable = true;
  services = {
    tlp.enable = true;
  };
}
