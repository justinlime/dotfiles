{ config, lib, pkgs, ... }:
let cfg = config.sysMods.kde; in 
  {
    options.sysMods.kde = with lib.types; {
      enable = lib.mkEnableOption "Enable";
    };
    config = lib.mkIf cfg.enable {
      environment.systemPackages = [
        (pkgs.catppuccin-kde.override {
          winDecStyles = [ "classic" ];
          flavour = [ "mocha" ];
          accents = [ "mauve" ];})
      ];
      xdg.portal = {
        enable = true;
      };
      programs.kdeconnect.enable = true;
      services = {
        displayManager.sddm = {
          enable = true;   
        };
        pipewire = {
          enable = true;
          audio.enable = true;
          alsa.enable = true;
          alsa.support32Bit = true;
          pulse.enable = true;
          wireplumber.enable = true;
        };
        desktopManager = {
          plasma6.enable = true;  
        };
      };
      # Fix icons from going blank after swapping generations
      systemd.services.fix-plasma-applications = {
        description = "Fix Plasma application paths for all users";
        wantedBy = [ "display-manager.service" ];
        before = [ "display-manager.service" ];
        serviceConfig = {
          Type = "oneshot";
          ExecStart = pkgs.writeShellScript "fix-plasma-applications" ''
            for home in /home/*; do
              config="$home/.config/plasma-org.kde.plasma.desktop-appletsrc"

              if [ -f "$config" ]; then
                echo "Fixing $config"
                ${pkgs.gnused}/bin/sed -i \
                  's|file:///nix/store/[^/]*/share/applications/|applications:|gi' \
                  "$config"
              fi
            done
          '';
        };
      };
    };
  }
