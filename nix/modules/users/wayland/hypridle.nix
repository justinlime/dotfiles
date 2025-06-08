{ config, lib, ... }:
let cfg = config.homeMods.hypridle; in
{
  options.homeMods.hypridle = with lib.types; {
    enable = lib.mkEnableOption "Enable";  
    lockTimeout = lib.mkOption  {
      default = 300;
      type = int;
    };
    sleepTimeout = lib.mkOption {
      default = 330;
      type = int;
    };
  };
  config = lib.mkIf cfg.enable {
    services.hypridle = {
      enable = true;  
      settings = {
        general = {
          after_sleep_cmd = "hyprctl dispatch dpms on";
          ignore_dbus_inhibit = false;
          lock_cmd = "hyprlock";
        };

        listener = [
          {
            timeout = cfg.lockTimeout;
            on-timeout = "hyprlock";
          }
          {
            timeout = cfg.sleepTimeout;
            on-timeout = "systemctl hibernate";
            on-resume = "hyprctl dispatch dpms on";
          }
        ];
      };
    }; 
  };
}
