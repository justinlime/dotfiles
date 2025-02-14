{ config, lib, pkgs, ... }:
let cfg = config.sysMods.docker; in 
{
  options.sysMods.docker = with lib.types; {
    enable = lib.mkEnableOption "Enable"; 
  };
  config = lib.mkIf cfg.enable {
    #Enable docker on the system and add the admin user to the docker group
    users.users.${config.sysMods.system.username}.extraGroups = [ "docker" ];
    environment.systemPackages = with pkgs; [
      docker-compose
    ];
    virtualisation.docker = {
      enable = true;
    };
  };
}
