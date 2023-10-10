{ 
    custom ? {
        font = "RobotoMono Nerd Font";
        primary_accent = "cba6f7";
        secondary_accent = "89b4fa";
        tertiary_accent = "f5f5f5";
        background = "11111B";
        opacity = "1";
    },
    ... 
}:
{
    programs.wofi = {
        enable = true;
        settings = {
            allow_images = true;
            width = "25%";
            hide_scroll = true;
            term = "foot";
            show = "drun";
        };
        style =''
        * {
          font-family: ${custom.font},monospace;
          font-weight: bold;
        }
        #window {
          border-radius: 40px;
          background: ${custom.palette.primary_background_rgba}
        }
        #input {
          border-radius: 100px;
          margin: 20px;
          padding: 15px 25px;
          background: ${custom.palette.tertiary_background_rgba};
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
          color: #${custom.background};
        }
        #entry:hover {
        }
        '';
    };
}
