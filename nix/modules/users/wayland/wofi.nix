{ lib, config, ... }:
let
  cfg = config.jfg.wofi;
  theme = config.jfg.theme;
  palette = theme.palette;
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
        font-family: ${theme.font.name},monospace;
        font-weight: bold;
      }
      #window {
        border-radius: 40px;
        background: #${palette.crust};
      }
      #input {
        border-radius: 100px;
        margin: 20px;
        padding: 15px 25px;
        background: #${palette.crust};
        color: #${palette.text};
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
        background-color:#${palette.mauve};
        color: #${palette.crust};
      }
      #entry:hover {
      }
      '';
    };
  };
}
