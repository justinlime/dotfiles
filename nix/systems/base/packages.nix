{ pkgs, inputs, flake_path, ... }:
{
    # List packages installed in system profile
    environment = {
        systemPackages = with pkgs; [
            pulseaudio #Needed for volume keys even with pipewire
            wireplumber
            wl-clipboard
        ];
        variables = { EDITOR = "vim"; };
        pathsToLink = [ "/share/zsh" ];
    };

    hardware.opengl.enable = true;
    #Programs
    programs = {
        dconf.enable = true;
        direnv.enable = true;
        hyprland.enable = true;
        thunar = {
            enable = true;
            plugins = with pkgs.xfce; [ 
                xfconf
                thunar-volman 
            ];
        };
    };
}

