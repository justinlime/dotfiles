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
    services.scx = {
      enable = lib.mkForce true;      
      scheduler = "scx_lavd";
    };
    services.ananicy = {
      enable = true;  
      package = pkgs.ananicy-cpp;
      rulesProvider = pkgs.ananicy-rules-cachyos;
      extraRules = [
        { "name" = "gamescope"; "nice" = "-20"; }
        { "name" = "gamescope-wl"; "nice" = "-20"; }
      ];
    };
    programs = {
      # VR
      # Install SteamVR via steam as well. 
      alvr = {
        enable = true;  
        openFirewall = true;
      };
      gamescope = {
        enable = true;
        # package = inputs.gamescopeNixpkgs.legacyPackages."x86_64-linux".gamescope;
        # package = pkgs.gamescope_git;
      };
      steam = {
        enable = true;
        # Runs steam in gamescope
        # gamescopeSession.enable = true;
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
        wineWowPackages.stable
        gamescope-wsi
        protonup-qt
        steam-run
        # Overlay
        mangohud
        mangojuice
        # Additional Launchers
        lutris
        heroic
        # Lossless Scaling
        lsfg-vk
        lsfg-vk-ui
        (steamtinkerlaunch.overrideAttrs (oldAttrs: {
          src = fetchFromGitHub {
            owner = "zany130";
            repo = "steamtinkerlaunch";
            rev = "a635314cb384b3a1ea8a3312e1c3ff9a7811a2af";
            hash = "sha256-a/929+wiDGa9O1zQvLa98IEovoboglpoKKyF4xxx7B0=";
          };
        }))
      ];
    };
  };
}
