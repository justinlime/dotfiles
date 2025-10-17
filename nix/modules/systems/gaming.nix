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
        {
          "name" = "gamescope";
          "nice" = "-20";
        }
        {
          "name" = "gamescope-wl";
          "nice" = "-20";
        }
      ];
    };
    programs = {
      gamescope = {
        enable = true;
        # package = inputs.gamescopeNixpkgs.legacyPackages."x86_64-linux".gamescope;
        package = pkgs.gamescope_git;
      };
      steam = {
        enable = true;
        # Runs steam in gamescope
        # gamescopeSession.enable = true;
      };
    };
    environment = {
      systemPackages = with pkgs; [
        mangohud_git
        mangojuice
        lutris
        heroic
        gamescope-wsi
        protonup-qt
        vkbasalt
        lsfg-vk
        lsfg-vk-ui
      ];
    };
  };
}
