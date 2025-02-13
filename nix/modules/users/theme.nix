{ lib, config, pkgs, ... }:
let cfg = config.jfg.theme; in 
{
  options.jfg.theme = with lib.types; {
    enable = lib.mkEnableOption "Enable"; 
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
    theme.name = lib.mkOption {
      default = "Catppuccin-GTK-Purple-Dark";
      type = str;
    };
    theme.package = lib.mkOption {
      default = pkgs.magnetic-catppuccin-gtk.override { accent = [ "purple" ]; };
      type = package;
    };
    palette = lib.mkOption {
      type = attrs;
      default = {
        black="11111B";
        red="ff5555";
        green="afffd7";
        yellow="f1fa8c";
        blue="87afff";
        magenta="bd93f9";
        cyan="8be9fd";
        white="f8f8f2";
        brightBlack="2d5b69";
        brightRed="ff665c";
        brightGreen="84c747";
        brightYellow="ebc13d";
        brightBlue="58a3ff";
        brightMagenta="ff84cd";
        brightCyan="53d6c7";
        brightWhite="cad8d9";
      }; 
    };
  };
  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.font.package ];
    qt = {
      enable = true;
      platformTheme.name = "gtk";
      style.name = "gtk2";
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
        name = cfg.theme.name;
        package = cfg.theme.package;
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
