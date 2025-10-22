{ lib, config, pkgs, ... }:
let cfg = config.homeMods.theme; in 
{
  options.homeMods.theme = with lib.types; {
    enable = lib.mkEnableOption "Enable"; 
    name = lib.mkOption {
      default = "Catppuccin-GTK-Purple-Dark";
      type = str;
    };
    package = lib.mkOption {
      default = pkgs.magnetic-catppuccin-gtk.override { accent = [ "purple" ]; };
      type = package;
    };
    font.name = lib.mkOption {
      default = "FiraCodeNerdFont";
      type = str;
    };
    font.package = lib.mkOption {
      default = pkgs.nerd-fonts.fira-code;
      type = package;
    };
    font.size = lib.mkOption {
      default = 12;
      type = int;
    };
    icon.name = lib.mkOption {
      default = "Papirus-Dark";
      type = str;
    };
    icon.package = lib.mkOption {
      default = pkgs.catppuccin-papirus-folders;
      type = package;
    };
    cursor.name = lib.mkOption {
      default = "Numix-Cursor";
      type = str;
    };
    cursor.package = lib.mkOption {
      default = pkgs.numix-cursor-theme;
      type = package;
    };
    palette = lib.mkOption {
      type = attrs;
      default = {
        rosewater = "f5e0dc";
        flamingo = "f2cdcd";
        pink = "f5c2e7";
        mauve = "cba6f7";
        red = "f38ba8";
        maroon = "eba0ac";
        peach = "fab387";
        yellow = "f9e2af";
        green = "a6e3a1";
        teal = "94e2d5";
        sky = "89dceb";
        sapphire = "74c7ec";
        blue = "89b4fa";
        lavender = "b4befe";
        text = "cdd6f4";
        subtext1 = "bac2de";
        subtext0 = "a6adc8";
        overlay2 = "9399b2";
        overlay1 = "7f849c";
        overlay0 = "6c7086";
        surface2 = "585b70";
        surface1 = "45475a";
        surface0 = "313244";
        base = "1e1e2e";
        mantle = "181825";
        crust = "11111b";
      }; 
    };
  };
  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.font.package ];
     qt = {
       enable = true;
     };
    gtk = {
      enable = true;
      font.name = "${cfg.font.name} ${builtins.toString cfg.font.size}";
      iconTheme = {
        name = cfg.icon.name;
        package = cfg.icon.package;
      };
      cursorTheme = {
        name = cfg.cursor.name;
        package = cfg.cursor.package;
      };
      theme = {
        name = cfg.name;
        package = cfg.package;
      };
      gtk3.extraConfig = {
        Settings = ''
          gtk-application-prefer-dark-theme=1
        '';
      };
      gtk4.extraConfig = {
        Settings = ''
          gtk-application-prefer-dark-theme=1
        '';
      };
    };
  };
}
