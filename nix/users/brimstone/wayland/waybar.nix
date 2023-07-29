{ custom, ... }:
{
    programs.waybar = {
        enable = true;
        settings.mainBar = {
            position= "top";
            layer= "top";
            height= 35;
            margin-top= 0;
            margin-bottom= 0;
            margin-left= 0;
            margin-right= 0;
            modules-left= [
                "custom/launcher" 
                "custom/playerctl#backward" 
                "custom/playerctl#play" 
                "custom/playerctl#foward" 
                "custom/playerlabel"
            ];
            modules-center= [
                "cava#left"
                "wlr/workspaces"
                "cava#right"
            ];
            modules-right= [
                "tray" 
                "pulseaudio" 
                "network"
                "clock" 
            ];
            clock= {
                format = " {:%a, %d %b, %I:%M %p}";
                tooltip= "true";
                tooltip-format= "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
                format-alt= " {:%d/%m}";
            };
            "wlr/workspaces"= {
                active-only= false;
                all-outputs= false;
                disable-scroll= false;
                on-scroll-up= "hyprctl dispatch workspace e-1";
                on-scroll-down= "hyprctl dispatch workspace e+1";
                format = "{name}";
                on-click= "activate";
                format-icons= {
                    urgent= "";
                    active= "";
                    default = "";
                    sort-by-number= true;
                };
            };
            "cava#left" = {
                framerate = 60;
                autosens = 1;
                sensitivity = 100;
                bars = 18;
                lower_cutoff_freq = 50;
                higher_cutoff_freq = 10000;
                method = "pipewire";
                source = "auto";
                stereo = true;
                reverse = false;
                bar_delimiter = 0;
                monstercat = false;
                waves = false;
                input_delay = 2;
                format-icons = [ "▁" "▂" "▃" "▄" "▅" "▆" "▇" "█" ];
            };
            "cava#right" = {
                framerate = 60;
                autosens = 1;
                sensitivity = 100;
                bars = 18;
                lower_cutoff_freq = 50;
                higher_cutoff_freq = 10000;
                method = "pipewire";
                source = "auto";
                stereo = true;
                reverse = false;
                bar_delimiter = 0;
                monstercat = false;
                waves = false;
                input_delay = 2;
                format-icons = [ "▁" "▂" "▃" "▄" "▅" "▆" "▇" "█" ];
            };
            "custom/playerctl#backward"= {
                format= "{icon}";
                return-type= "json";
                max-length= 64;
                exec= "playerctl -a metadata --format '{\"text\": \"{{artist}} - {{markup_escape(title)}}\", \"tooltip\": \"{{playerName}} : {{markup_escape(title)}}\", \"alt\": \"{{status}}\", \"class\": \"{{status}}\"}' -F";
                on-click= "playerctl previous";
                format-icons= {
                    Playing= "<span foreground='#${custom.accent}'>󰙣 </span>";
                    Paused= "<span foreground='#${custom.accent}'>󰙣 </span>";
                };
            };
            "custom/playerctl#play"= {
                format= "{icon}";
                return-type= "json";
                max-length= 64;
                exec= "playerctl -a metadata --format '{\"text\": \"{{artist}} - {{markup_escape(title)}}\", \"tooltip\": \"{{playerName}} : {{markup_escape(title)}}\", \"alt\": \"{{status}}\", \"class\": \"{{status}}\"}' -F";
                on-click= "playerctl play-pause";
                format-icons= {
                    Playing= "<span foreground='#6791eb'>󰏥 </span>";
                    Paused= "<span foreground='#cdd6f4'> </span>";
                };
            };
            "custom/playerctl#foward"= {
                format= "{icon}";
                return-type= "json";
                max-length= 64;
                exec= "playerctl -a metadata --format '{\"text\": \"{{artist}} - {{markup_escape(title)}}\", \"tooltip\": \"{{playerName}} : {{markup_escape(title)}}\", \"alt\": \"{{status}}\", \"class\": \"{{status}}\"}' -F";
                on-click= "playerctl next";
                format-icons= {
                    Playing= "<span foreground='#${custom.accent}'>󰙡 </span>";
                    Paused= "<span foreground='#${custom.accent}'>󰙡 </span>";
                };
            };
            "custom/playerlabel"= {
                format= "<span>{}</span>";
                return-type= "json";
                max-length= 48;
                exec= "playerctl -a metadata --format '{\"text\": \"{{artist}} - {{markup_escape(title)}}\", \"tooltip\": \"{{playerName}} : {{markup_escape(title)}}\", \"alt\": \"{{status}}\", \"class\": \"{{status}}\"}' -F";
                on-click= "";
            };
            battery= {
                states= {
                    good= 95;
                    warning= 30;
                    critical= 15;
                };
                format="{icon}  {capacity}%";
                format-charging= "{capacity}% ";
                format-plugged= "{capacity}% ";
                format-alt= "{icon} {time}";
                format-icons= ["" "" "" "" ""];
            };

            memory= {
                format= "󰍛 {}%";
                format-alt= "󰍛 {used}/{total} GiB";
                interval= 5;
            };
            cpu= {
                format= "󰻠 {usage}%";
                format-alt= "󰻠 {avg_frequency} GHz";
                interval= 5;
            };
            network = {
                format-wifi = " {signalStrength}%";
                format-ethernet = "󰈀 100% ";
                tooltip-format = "Connected to {essid} {ifname} via {gwaddr}";
                format-linked = "{ifname} (No IP)";
                format-disconnected = "󰖪 0% ";
            };
            tray= {
                icon-size= 20;
                spacing= 8;
            };
            pulseaudio= {
                format= "{icon} {volume}%";
                format-muted= "󰝟";
                format-icons= {
                    default= ["󰕿" "󰖀" "󰕾"];
                };
                on-click= "bash ~/.scripts/volume mute";
                on-scroll-up= "bash ~/.scripts/volume up";
                on-scroll-down= "bash ~/.scripts/volume down";
                scroll-step= 5;
                on-click-right= "pavucontrol";
            };
            "custom/randwall"= {
                format= "󰏘";
                on-click= "bash $HOME/.config/hypr/randwall.sh";
                on-click-right= "bash $HOME/.config/hypr/wall.sh";
            };
            "custom/launcher"= {
                format= "";
                on-click= "bash $HOME/.config/rofi/launcher.sh";
                on-click-right= "bash $HOME/.config/rofi/run.sh"; 
                tooltip= "false";
            };
        };
        style = ''
            * {
                border: none;
                border-radius: 0px;
                font-family: ${custom.font}, monospace;
                font-size: 14px;
                min-height: 0;
            }

            window#waybar {
                background: rgba(16, 18, 19, 0.8);
                border-bottom: 1px solid #0c0e0f;
            }

            #workspaces {
              background: #${custom.background};
              margin: 5px 5px;
              padding: 8px 5px;
              border-radius: 16px;
              border: solid 0px #cdd6f4;
              font-weight: normal;
              font-style: normal;
            }

            #cava.left {
                background: #${custom.background};
                margin: 5px 5px;
                padding: 8px 16px;
                color: #${custom.accent};
                border-radius: 16px;
                border-radius: 24px 10px 24px 10px;
            }
            #cava.right {
                background: #${custom.background};
                margin: 5px 5px;
                padding: 8px 16px;
                color: #${custom.accent};
                border-radius: 10px 24px 10px 24px;
            }
            #workspaces button {
                padding: 0px 5px;
                margin: 0px 3px;
                border-radius: 16px;
                color: #2f354a;
                background-color: #2f354a;
                transition: all 0.3s ease-in-out;
            }

            #workspaces button.active {
                background-color: #${custom.accent};
                border-radius: 16px;
                min-width: 50px;
                background-size: 400% 400%;
                transition: all 0.3s ease-in-out;
            }

            #workspaces button:hover {
                background-color: #cdd6f4;
                color: #cdd6f4;
                border-radius: 16px;
                min-width: 50px;
                background-size: 400% 400%;
            }

            #tray, #pulseaudio, #network{
                background: #${custom.background};
                margin: 5px 5px 5px 5px;
                padding: 0 12px;
                border-radius: 10px 24px 10px 24px;
                /*border-right: solid 1px #282738;*/
            }

            #clock {
                color: #cdd6f4;
                background-color: #${custom.background};
                border-radius: 0px 0px 0px 24px;
                padding: 0 20px;
                margin-right: 0px;
                margin-left: 10px;
                margin-top: 0px;
                margin-bottom: 0px;
                font-weight: bold;
            }


            #battery {
                color: #9ece6a;
            }

            #battery.charging {
                color: #9ece6a;
            }

            #battery.warning:not(.charging) {
                background-color: #f7768e;
                color: #24283b;
                border-radius: 5px 5px 5px 5px;
            }

            #network, #pulseaudio {
                color: #cdd6f4;
                margin-right: 5px;
                font-weight: bold;
                padding: 0 20px;
            }

            #pulseaudio.muted {
                color: #242f33;
                margin-left: 0px;
                font-weight: bold;
            }

            #custom-launcher {
                color: #cdd6f4;
                background-color: #${custom.background};
                border-radius: 0px 0px 24px 0px;
                margin: 0px 0px 0px 0px;
                padding: 0 20px 0 13px;
                /*border-right: solid 1px #282738;*/
                font-size: 24px;
            }

            #custom-launcher button:hover {
                background-color: #FB4934;
                color: transparent;
                border-radius: 8px;
                margin-right: -5px;
                margin-left: 10px;
            }

            #custom-playerctl.backward {
                background: #${custom.background};
                padding-left: 20px;
                padding-right: 10px;
                border-radius: 24px 0px 0px 10px;
                /*border-left: solid 1px #282738;*/
                /*border-right: solid 1px #282738;*/
                margin: 5px 0px;
                margin-left: 10px;
                color: whitesmoke;
                font-weight: bold;
                font-style: normal;
                font-size: 18px;
            }
            #custom-playerctl.play {
                background: #${custom.background};
                /*border-left: solid 1px #282738;*/
                /*border-right: solid 1px #282738;*/
                margin: 5px 0px;
                color: whitesmoke;
                font-weight: bold;
                font-style: normal;
                font-size: 18px;
            }
            #custom-playerctl.foward {
                background: #${custom.background};
                padding-left: 10px;
                padding-right: 10px;
                border-radius: 0px 10px 24px 0px;
                margin: 5px 0px;
                /*border-left: solid 1px #282738;*/
                /*border-right: solid 1px #282738;*/
                color: whitesmoke;
                font-weight: bold;
                font-style: normal;
                font-size: 18px;
                margin-right: 10px;
            }

            #custom-playerlabel {
                background: #${custom.background};
                padding: 0 20px;
                border-radius: 24px 10px 24px 10px;
                /*border-left: solid 1px #282738;*/
                /*border-right: solid 1px #282738;*/
                margin-top: 5px;
                margin-bottom: 5px;
                font-weight: normal;
                font-style: normal;
                color: whitesmoke;
            }

            #window{
                background: #0c0e0f;
                padding-left: 15px;
                padding-right: 15px;
                border-radius: 16px;
                /*border-left: solid 1px #282738;*/
                /*border-right: solid 1px #282738;*/
                margin-top: 5px;
                margin-bottom: 5px;
                font-weight: normal;
                font-style: normal;
            }

            #cpu {
                background-color: #0c0e0f;
                /*color: #FABD2D;*/
                border-radius: 16px;
                margin: 5px;
                margin-left: 5px;
                margin-right: 5px;
                padding: 0px 10px 0px 10px;
                font-weight: bold;
            }

            #memory {
                background-color: #0c0e0f;
                /*color: #83A598;*/
                border-radius: 16px;
                margin: 5px;
                margin-left: 5px;
                margin-right: 5px;
                padding: 0px 10px 0px 10px;
                font-weight: bold;
            }
        '';
    };
}
