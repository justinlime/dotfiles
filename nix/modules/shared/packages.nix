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
  tree
  compsize
  smartmontools
  vim
  pciutils
  websocat
  lm_sensors
  maxfetch
  # veracrypt
  # roboto
  git-crypt
  # (ffmpeg-full.override { withSvtav1 = true; svt-av1=pkgs.svt-av1-psy; })
  # (av1an.override { withSvtav1 = true; svt-av1=pkgs.svt-av1-psy; })
  # podman-tui
  fastfetch
  # (nerdfonts.override { fonts = [ "FiraCode" ]; })
  # inputs.fileserver.packages.${pkgs.system}.default
]
