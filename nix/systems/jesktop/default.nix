{ pkgs, ... }:
{
  imports = [ 
    ./hardware-configuration.nix 
  ];
  sysMods = {
    system = rec {
      username = "justinlime";  
      flakeDirectory = "/home/${username}/dotfiles";
    }; 
    usbautomount.enable = true;
    # hyprland.enable = true;
    virt.enable = true;
    kde.enable = true;
    # gnome.enable = true;
    ssh.enable = true;
    gaming.enable = true;
    firewall = {
      enable = true;  
      BothPorts = [ 1313 6969 1317 ];
    };
  };
  nixpkgs.config.cudaSupport = true;
  programs.obs-studio = {
    enable = true; 
    enableVirtualCamera = true;
    # package = (pkgs.obs-studio.override {
    #   cudaSupport = true;
    # });
  };
  networking.hostName = "jesktop";
  hardware.ledger.enable = true;
  services.flatpak.enable = true;
  environment.systemPackages = [ pkgs.nvtopPackages.full pkgs.discord ];
}
