{ pkgs, inputs, ... }:
{
    #Overlays/Overrides
    nixpkgs.overlays = [
        (self: super: {
         waybar = super.waybar.overrideAttrs (oldAttrs: {
                 mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
                 });
         })
    ];

    programs.direnv.enable = true;
    fonts.fontconfig.enable = true;

    #Packages
    home.packages = with pkgs; [
        brave
        firefox
        foot
        gimp
        go
        grim
        glibc
        libsForQt5.dolphin
        mpv
        neofetch
        neovide
        neovim
        obs-studio
        pavucontrol
        prismlauncher
        slurp
        swaybg
        swayidle
        swaylock-effects
        swaynotificationcenter
        speedtest-cli
        tdesktop
        waybar
        wofi
        zig
        playerctl
        inputs.maxfetch.packages."x86_64-linux".default
        (nerdfonts.override { fonts = [ "JetBrainsMono" "Iosevka" "RobotoMono" "AnonymousPro" ]; })
    ];
}
