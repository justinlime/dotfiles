{ config, pkgs, lib, ... }:
let
    username = "justinlime";
in
{
    imports =
        [ 
        ./dotfiles.nix 
        ];

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;
    nixpkgs.config.allowUnfree = true;
    home.shellAliases = {
        home-switch = "home-manager switch --flake ~/dotfiles#justinlime";
    };

    # Home Manager needs a bit of information about you and the
    # paths it should manage.
    home.username = "${username}";
    home.homeDirectory = "/home/${username}";

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
        # (discord.override { withOpenASAR = true; withVencord = true;})
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

    # This value determines the Home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new Home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.
    home.stateVersion = "22.11";
    }
