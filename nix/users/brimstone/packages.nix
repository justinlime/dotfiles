{pkgs, ... }:
{
        #Overlays/Overrides
        nixpkgs.overlays = [
            (self: super: {
             waybar = super.waybar.overrideAttrs (oldAttrs: {
                     mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
                     });
             })
        ];

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
            webcord-vencord
            wofi
            zig
            (nerdfonts.override { fonts = [ "JetBrainsMono" "Iosevka" "RobotoMono" "AnonymousPro" ]; })

            #language servers:
            lua-language-server #Lua
            nil #Nix
            gopls #Golang
            rust-analyzer #Rust
            zls #Zig
            llvmPackages_15.clang-unwrapped #C, C++
            python311Packages.jedi-language-server #Python
            nodePackages_latest.vscode-langservers-extracted #HTML,CSS, JSON
            nodePackages_latest.grammarly-languageserver #Markdown
            nodePackages_latest.typescript-language-server #Javascript and Typescript
            nodePackages_latest.bash-language-server #Bash
            nodePackages_latest.dockerfile-language-server-nodejs #Dockerfiles
            nodePackages_latest.yaml-language-server #Yaml
        ];
}
