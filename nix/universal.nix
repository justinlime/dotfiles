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
  duf
  btop
  gnutar
  speedtest-cli
  neofetch
  tree
  compsize
  smartmontools
  vim
  pciutils
  websocat
  lm_sensors
  maxfetch
  veracrypt
  roboto
  git-crypt
  ffmpeg-full
  podman-tui
  (nerdfonts.override { fonts = [ "FiraCode" ]; })
  inputs.fileserver.packages.${pkgs.system}.default
]
