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

    #Services
    services = {
        tlp.enable = true;
    };
}
