{ lib, config, ... }:
let
  cfg = config.jfg.wofi;
  custom = {
    primary_accent = "cba6f7";
    secondary_accent = "89b4fa";
    tertiary_accent = "f5f5f5";
    primary_background = "11111B";
    secondary_background = "1b1b2b";
    tertiary_background = "25253a";
  };
in
{
  options.jfg.wofi = with lib.types; {
    enable = lib.mkEnableOption "Enable";
  };
  config = lib.mkIf cfg.enable {
    programs.wofi = {
      enable = true;
      settings = {
          allow_images = true;
          width = "50%";
          hide_scroll = true;
          term = "foot";
          show = "drun";
      };
      style =''
      * {
        font-family: ${config.jfg.theme.font.name},monospace;
        font-weight: bold;
      }
      #window {
        border-radius: 40px;
        background: #${custom.primary_background};
      }
      #input {
        border-radius: 100px;
        margin: 20px;
        padding: 15px 25px;
        background: #${custom.primary_background};
        color: #${custom.tertiary_accent};
      }
      #outer-box {
        font-weight: bold;
        font-size: 14px;
      }
      #entry {
        margin: 10px 80px;
        padding: 20px 20px;
        border-radius: 200px;
      }
      #entry:selected{
        background-color:#${custom.primary_accent};
        color: #${custom.primary_background};
      }
      #entry:hover {
      }
      '';
    };
  };
}
