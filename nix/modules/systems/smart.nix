{ config, lib, ... }:
let cfg = config.jfg.smart; in 
{
  options.jfg.smart = with lib.types; {
    enable = mkEnableOption "Enable";
  };
  config = lib.mkIf cfg.enable {
    services.smartd = {
      enable = true;
      autodetect = true;
      # Run short self tests daily, long self tests monthly
      defaults.autodetected = "-a -o on -s (S/../.././02|L/01/../../04)";
    };
  };
}
