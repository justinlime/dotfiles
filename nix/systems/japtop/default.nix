{ flake_path, ... }:
{
    imports =
        [ # Include the results of the hardware scan.
        ./hardware-configuration.nix 
        ../base
        ];

    #Programs
    programs = {
      light.enable = true;
    };

    networking.hostName = "japtop";
    #Services
    services = {
        tlp.enable = true;
    };
}
