{ pkgs, config, lib, inputs, ... }:
let cfg = config.sysMods.gaming; in 
{
  options.sysMods.gaming = with lib.types; {
    enable = lib.mkEnableOption "Enable";  
  };
  config = lib.mkIf cfg.enable {
    # System
    users.users.${config.sysMods.system.username}.extraGroups = [ "gamemode" ];
    fonts.packages = with pkgs; [ vista-fonts corefonts ];
    programs = {
      gamescope = {
        enable = true;
        # package = pkgsStable.gamescope;
      };
      gamemode = {
        enable = true; 
        enableRenice = true; 
      };
      steam = {
        enable = true;
        # Runs steam in gamescope
        # gamescopeSession.enable = true;
        package = pkgs.steam.override {
          # Taken from https://github.com/NixOS/nixpkgs/issues/162562#issuecomment-1523177264
          # Fixes gamescope from being borked on nix
          # Examples usage for games:

          # Run the game natively at 1440p, upsacle to 2160p, use gamemode to optimize
          # gamemoderun gamescope -f -h 1440 -H 2160 -r 144 --rt --force-grab-cursor -- mangohud %command%
          extraPkgs = pkgs: with pkgs; [
            xorg.libXcursor
            xorg.libXi
            xorg.libXinerama
            xorg.libXScrnSaver
            libpng
            libpulseaudio
            libvorbis
            stdenv.cc.cc.lib
            libkrb5
            keyutils
          ];
        };
      };
    };
    environment = {
      systemPackages = with pkgs; [
        goverlay
        mangohud
        protonup-qt
      ];
    };
  };
}
