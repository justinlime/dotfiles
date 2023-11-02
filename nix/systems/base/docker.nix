{ config, lib, username, pkgs, inputs, ... }:
{
  #Enable docker on the system and add the admin user to the docker group
	users.users.${username}.extraGroups = [ "docker" ];
	environment.systemPackages = with pkgs; [
		docker-compose
	];
	virtualisation.docker = {
		enable = true;
		storageDriver = "btrfs";
	};
}
