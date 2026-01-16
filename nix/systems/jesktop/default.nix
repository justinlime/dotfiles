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
  networking.hostName = "jesktop";
  hardware.ledger.enable = true;
  services.flatpak.enable = true;
<<<<<<< Updated upstream
  environment.systemPackages = [ pkgs.nvtopPackages.full ];
  
=======
  # services.displayManager.ly.enable = true;
  environment.systemPackages = [ pkgs.nvtopPackages.full ];
  
  # programs.dankMaterialShell = {
  #   enable = true;
  # 
  #   systemd = {
  #     enable = true;             # Systemd service for auto-start
  #     restartIfChanged = true;   # Auto-restart dms.service when dms-shell changes
  #   };
  # 
  #   # Core features
  #   enableSystemMonitoring = true;     # System monitoring widgets (dgop)
  #   enableClipboard = true;            # Clipboard history manager
  #   enableVPN = true;                  # VPN management widget
  #   enableDynamicTheming = true;       # Wallpaper-based theming (matugen)
  #   enableAudioWavelength = true;      # Audio visualizer (cava)
  #   enableCalendarEvents = true;       # Calendar integration (khal)
  # };
>>>>>>> Stashed changes
}
