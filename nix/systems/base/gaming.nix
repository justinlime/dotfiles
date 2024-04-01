{ pkgs, inputs, username, pkgsStable, ... }:
{
  # System

  users.users.${username}.extraGroups = [ "gamemode" ];
  programs = {
    gamescope = {
      enable = true;
      # package = pkgsStable.gamescope;
    };
    gamemode = {
      enable = true; 
      enableRenice = true; 
      settings = {
        custom = {
          # Set the monitor to an unreachable location to lock the mouse to the monitor
          # with the current version of gamescope it escapes :(
          start = "${inputs.hyprland.packages.${pkgs.system}.hyprland}/bin/hyprctl keyword monitor DP-2,2560x1440@165,3840x0,1";
          end = "${inputs.hyprland.packages.${pkgs.system}.hyprland}/bin/hyprctl keyword monitor DP-2,2560x1440@165,2560x0,1";
        }; 
      };
    };

    steam = {
      enable = true;
      gamescopeSession.enable = true;
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
  hardware = {
    opengl.enable = true; 
  };
  environment = {
    systemPackages = with pkgs; [
      goverlay
      mangohud
      protonup-qt
    ];
  };

}
