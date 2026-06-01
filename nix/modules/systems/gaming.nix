{ pkgs, config, lib, inputs, ... }:
let cfg = config.sysMods.gaming; in 
{
  options.sysMods.gaming = with lib.types; {
    enable = lib.mkEnableOption "Enable";  
  };
  config = lib.mkIf cfg.enable {
    # System
    users.users.${config.sysMods.system.username}.extraGroups = [ "gamemode" ];
    # Windows Fonts and shit
    fonts.packages = with pkgs; [ vista-fonts corefonts ];
    services= {
      # scx = {
      #   enable = lib.mkForce true;      
      #   scheduler = "scx_lavd";
      # };
      # Install SteamVR via steam as well. 
      # Add this launch option to games:
      # PRESSURE_VESSEL_FILESYSTEMS_RW=$XDG_RUNTIME_DIR/wivrn/comp_ipc %command%
      wivrn = {
        enable = true;  
        openFirewall = true;
        autoStart = true;
        package = (pkgs.wivrn.override { cudaSupport = true; });
      };
    };
    programs = {
      gamemode = {
        enable = true;
        settings = {
          general = {
            renice = 10;
          };
          custom = {
            start = "${pkgs.libnotify}/bin/notify-send 'GameMode started'";
            end = "${pkgs.libnotify}/bin/notify-send 'GameMode ended'";
          };
        }
        ;  
      };
      gamescope = {
        enable = true;
        # package = inputs.gamescopeNixpkgs.legacyPackages."x86_64-linux".gamescope;
        # package = pkgs.gamescope_git;
      };
      steam = {
        enable = true;
        package = pkgs.steam.override {
          extraPkgs = pkgs: with pkgs; [
            gamemode
          ];
        };
      };
    };
    environment = {
      variables = {
       # "KWIN_FORCE_SW_CURSOR" = "1"; 
       # "KWIN_DRM_NO_AMS" = "1"; 
      };
      systemPackages = with pkgs; [
        # Compatibility
        winetricks
        # wineWow64Packages.stable
        gamescope-wsi
        protonup-qt
        steam-run
        # Overlay
        mangohud
        mangojuice
        # Additional Launchers
        # lutris
        heroic
        # Lossless Scaling
        lsfg-vk
        lsfg-vk-ui
      ];
    };
  };
}
