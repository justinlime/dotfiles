{ config, lib, pkgs, ... }:
let cfg = config.jfg.docker; in 
{
  options.jfg.docker = with lib.types; {
    enable = mkEnableOption "Enable"; 
  };
  config = lib.mkIf cfg.enable {
    #Enable docker on the system and add the admin user to the docker group
    users.users.${config.jfg.system.username}.extraGroups = [ "docker" ];
    environment.systemPackages = with pkgs; [
      docker-compose
    ];
    virtualisation.docker = {
      enable = true;
    };
  };
}
