{ config, lib, pkgs, inputs, ... }:
{
	users.users.justinlime.extraGroups = [ "docker" ];
	environment.systemPackages = with pkgs; [
		docker-compose
	];
	virtualisation.docker = {
		enable = true;
		storageDriver = true;
	};
}