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

    #Packages
    home.packages = with pkgs; [
        brave
        firefox
        foot
        gimp
        go
        grim
        glibc
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
        inputs.maxfetch.packages.${pkgs.system}.default
        # haskell
        haskell.compiler.native-bignum.ghcHEAD
    ];
}
