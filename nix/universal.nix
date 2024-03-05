# Universal packages I will want regardless of system, or home-manager profile 
pkgs: inputs:
with pkgs; [
  git
  curl
  wget
  coreutils-full
  zip
  unzip
  bat
  gnutar
  btop
  speedtest-cli
  neofetch
  tree
  compsize
  smartmontools
  vim
  pciutils
  websocat
  lm_sensors
  inputs.maxfetch.packages.${pkgs.system}.default
  roboto
  git-crypt
  (nerdfonts.override { fonts = [ "RobotoMono" ]; })
]
