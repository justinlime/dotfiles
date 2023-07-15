{ config, pkgs, lib, ... }:
let 
    font = "RobotoMono Nerd Font";
    fontsize = "12";
    accent = "cba6f7";
    background = "11111B";
    opacity = ".85";
    cursor = "Numix-Cursor";
in
{
    xdg.configFile = {
        "nvim".source = ../../../.config/nvim;
    };
    fonts.fontconfig.enable = true;
    gtk = {
        enable = true;
        font.name = "${font} ${fontsize}";
        iconTheme = {
            name = "Papirus-Dark";
            package = pkgs.catppuccin-papirus-folders;
        };
        cursorTheme = {
            name = "${cursor}";
            package = pkgs.numix-cursor-theme;
        };
        theme = {
            name = "Catppuccin-Mocha-Standard-Blue-dark";
            package = pkgs.catppuccin-gtk.override { variant="mocha"; };
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
    qt = {
        enable = true;
        platformTheme = "gtk";
        style.name = "gtk2";
    };
    programs = {
        foot = {
            enable = true;
            server.enable = true;
            settings = {
                main = {
                    font = "${font}:size=${fontsize}";
                    pad = "25x15 center";
                    dpi-aware = "no";
                };
                colors = {
                    alpha="${opacity}";
                    background="${background}";
                    regular0="11111B";  # black
                    regular1="ff5555";  # red
                    regular2="afffd7";  # green
                    regular3="f1fa8c";  # yellow
                    regular4="87afff";  # blue
                    regular5="bd93f9";  # magenta
                    regular6="8be9fd";  # cyan
                    regular7="f8f8f2";  # white
                    bright0="2d5b69";   # bright black
                    bright1="ff665c";   # bright red
                    bright2="84c747";   # bright green
                    bright3="ebc13d";   # bright yellow
                    bright4="58a3ff";   # bright blue
                    bright5="ff84cd";   # bright magenta
                    bright6="53d6c7";   # bright cyan
                    bright7="cad8d9";   # bright white
                };
            };
        };
        waybar = {
            enable = true;
            settings.mainBar = {
                layer = "top";
                height = 35;
                spacing = 4;
                modules-left = ["wlr/workspaces"];
                modules-center = ["clock"];
                # modules-right = ["pulseaudio" "network" "cpu" "memory" "temperature" "battery" "clock" "tray"];
                modules-right = ["pulseaudio" "network" "cpu" "memory" "temperature" "battery" "tray"];
                clock = {
                    timezone = "America/Chicago";
                    tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
	                format = "{:%a, %d %b, %I:%M %p}";
                };
                battery = {
                    states = {
                        good = 95;
                        warning = 30;
                        critical = 15;
                    };
                        format = "{capacity}% {icon}";
                        format-charging = "{capacity}% ";
                        format-plugged = "{capacity}% ";
                        format-alt = "{time} {icon}";
                        format-icons = ["" "" "" "" ""];
                };
                network = {
                    # format-wifi = "{essid} ({signalStrength}%) ";
                    format-wifi = "{signalStrength}% ";
                        format-ethernet = "100% 󰈀";
                        tooltip-format = "Connected to {essid} {ifname} via {gwaddr}";
                        format-linked = "{ifname} (No IP)";
                        format-disconnected = "0% 󰖪";
                        # format-alt = "{ifname}: {ipaddr}/{cidr}";
                };
                pulseaudio = {
                    format = "{volume}% {icon} {format_source}";
                        format-bluetooth = "{volume}% {icon} {format_source}";
                        format-bluetooth-muted = "{icon} {format_source}";
                        format-muted = "{format_source}";
                        format-source = "{volume}% ";
                        format-source-muted = "";
                        format-icons = {
                            headphone = "";
                            hands-free = "";
                            headset = "";
                            phone = "";
                            portable = "";
                            car = "";
                            default = ["" "" ""];
                        };
                        on-click = "pavucontrol";
                };
                tray = {
                    spacing = 10;
                };
                cpu = {
                    format = "{usage}% ";
                        tooltip = false;
                };
                memory = {
                    format = "{}% ";
                };
                temperature = {
                        format = "{temperatureC}°C {icon}";
                        format-icons = [""];
                };
            };
            style = ''
                * {
                    font-family: ${font}, sans-serif;
                    font-size: 16px;
                    color: #${accent};
                }

                window#waybar {
                    background: none;
                    border-bottom: none;
                    transition-duration: .5s;
                }

                #workspaces button.active{
                    color: #${accent};
                    border-radius: 10px;
                    box-shadow: inset 0 -3px #${accent};
                }
                
                #clock,#battery,#cpu,#memory,#temperature,
                #network,#pulseaudio,#tray, #workspaces {
                    margin-top: .70rem;
                    background: #${background};
                    opacity: ${opacity};
                    padding: 0 1rem;
                    border-radius: .75rem;
                }
                #battery{
                    padding-right: 1.75rem;
                }
                #network{
                    padding-right: 1.5rem;
                }
                #memory,
                #cpu{
                    padding-right: 1.25rem;
                }
                #tray{
                    margin-right: .5rem;
                }
                /* If workspaces is the leftmost module, omit left margin */
                .modules-left > widget:first-child > #workspaces {
                    margin-left: .9rem;
                }

                .modules-right{
                    margin-right: .70rem;
                }

                /* If workspaces is the rightmost module, omit right margin */
                .modules-right > widget:last-child > #workspaces {
                    margin-right: .9rem;
                }

                '';
        };
        zsh = {
            enable = true;
            autocd = true;
            enableAutosuggestions = true;
            enableCompletion = true;
            syntaxHighlighting.enable = true;
            # this shit doesnt fuggin work
            # dotDir = ".config/zsh";
            # history.path = ".config/zsh/.zsh_history";
            initExtra = ''
            setopt appendhistory
            parse_git_branch() {
              git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
            }
            setopt PROMPT_SUBST
            PROMPT='%B%F{183}%m%f%F{111}[%f%F{158}%~%f%F{111}]%f%F{111}$(parse_git_branch)%f %F{183}>%f%f%b '
            '';
        };
    };
    home.file = {
        ".config/hypr/hyprland.conf".text = ''
        
    # See https://wiki.hyprland.org/Configuring/Monitors/
        monitor=,preferred,auto,auto
        monitor=eDP-1,1920x1080@60,0x0,1
        exec-once=waybar
        exec-once=swaybg -i ~/photos/wallpapers/wallpaper.png
        exec-once=swayidle -w timeout 1800 'swaylock -f -i ~/photos/wallpapers/wallpaper.png' timeout 1805 'swaymsg "output * dpms off"' resume 'swaymsg "output * dpms on"' before-sleep 'swaylock -f -i ~/photos/wallpapers/wallpaper.png'
        exec-once=hyprctl setcursor ${cursor} ${fontsize}
        exec-once=swaync
      
     # See https://wiki.hyprland.org/Configuring/Keywords/ for more

     # Execute your favorite apps at launch
     # exec-once = waybar & hyprpaper & firefox

     # Source a file (multi-file configs)
     # source = ~/.config/hypr/myColors.conf

    # For all categories, see https://wiki.hyprland.org/Configuring/Variables/
        input {
            kb_layout = us
            kb_variant =
            kb_model =
            kb_options =
            kb_rules =

            follow_mouse = 1

            touchpad {
                natural_scroll = true
            }

            sensitivity = 0 # -1.0 - 1.0, 0 means no modification.
        }

        general {
            # See https://wiki.hyprland.org/Configuring/Variables/ for more

            gaps_in = 6
            gaps_out = 10
            border_size = 1
            #col.active_border = rgba(33ccffee) #rgba(00ff99ee) 45deg
            col.active_border = rgb(${accent})
            col.inactive_border = rgb(${background})

            layout = dwindle
        }

        decoration {
            # See https://wiki.hyprland.org/Configuring/Variables/ for more

            rounding = 10
            blur = yes
            blur_size = 4
            blur_passes = 3
            blur_new_optimizations = true

            drop_shadow = no
            shadow_range = 0
            shadow_render_power = 4
            col.shadow = rgb(${accent})
            col.shadow_inactive = rgb(${background})         
        }

        animations {
            enabled = yes

            # Some default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more

            bezier=overshot,0.13,0.99,0.29,1.1
            animation=windows,1,6,overshot,slide
            animation=border,1,10,default
            animation=fade,1,10,default
            animation=workspaces,1,6,overshot,slide
        }


        dwindle {
            # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
            pseudotile = yes # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
            preserve_split = yes # you probably want this
            force_split=2 #Forces split to the right instead of following mouse
        }

        master {
            # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
            new_is_master = true
        }

        gestures {
            # See https://wiki.hyprland.org/Configuring/Variables/ for more
            workspace_swipe = off
        }

    # Example per-device config
    # See https://wiki.hyprland.org/Configuring/Keywords/#executing for more
        device:epic mouse V1 {
            sensitivity = -0.5
        }

    # Example windowrule v1
     # windowrule = float, ^(kitty)$
     # Example windowrule v2
     # windowrulev2 = float,class:^(kitty)$,title:^(kitty)$
     # See https://wiki.hyprland.org/Configuring/Window-Rules/ for more


     # See https://wiki.hyprland.org/Configuring/Keywords/ for more
        $mainMod = ALT 

     # Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
        bind = $mainMod, RETURN, exec, foot
        bind = $mainMod SHIFT, Q, killactive, 
        bind = $mainMod SHIFT, X, exit, 
        bind = $mainMod, E, togglefloating, 
        bind = $mainMod, D, exec, wofi --show drun
        bind = $mainMod, V, pseudo,     # dwindle
        bind = $mainMod, W, togglesplit, # dwindle
        bind = $mainMod, F, fullscreen,
    
    # Move focus with mainMod + arrow keys
        bind = $mainMod, H, movefocus, l
        bind = $mainMod, L, movefocus, r
        bind = $mainMod, K, movefocus, u
        bind = $mainMod, J, movefocus, d

    #moving windows
        bind=$mainMod SHIFT,H,movewindow,l
        bind=$mainMod SHIFT,L,movewindow,r
        bind=$mainMod SHIFT,K,movewindow,u
        bind=$mainMod SHIFT,J,movewindow,d


    # Switch workspaces with mainMod + [0-9]
        bind = $mainMod, 1, workspace, 1
        bind = $mainMod, 2, workspace, 2
        bind = $mainMod, 3, workspace, 3
        bind = $mainMod, 4, workspace, 4
        bind = $mainMod, 5, workspace, 5
        bind = $mainMod, 6, workspace, 6
        bind = $mainMod, 7, workspace, 7
        bind = $mainMod, 8, workspace, 8
        bind = $mainMod, 9, workspace, 9
        bind = $mainMod, 0, workspace, 10

    # Move active window to a workspace with mainMod + SHIFT + [0-9]
        bind = $mainMod SHIFT, 1, movetoworkspace, 1
        bind = $mainMod SHIFT, 2, movetoworkspace, 2
        bind = $mainMod SHIFT, 3, movetoworkspace, 3
        bind = $mainMod SHIFT, 4, movetoworkspace, 4
        bind = $mainMod SHIFT, 5, movetoworkspace, 5
        bind = $mainMod SHIFT, 6, movetoworkspace, 6
        bind = $mainMod SHIFT, 7, movetoworkspace, 7
        bind = $mainMod SHIFT, 8, movetoworkspace, 8
        bind = $mainMod SHIFT, 9, movetoworkspace, 9
        bind = $mainMod SHIFT, 0, movetoworkspace, 10

    # Scroll through existing workspaces with mainMod + scroll
        bind = $mainMod, mouse_down, workspace, e+1
        bind = $mainMod, mouse_up, workspace, e-1

    # Move/resize windows with mainMod + LMB/RMB and dragging
        bindm = $mainMod, mouse:272, movewindow
        bindm = $mainMod SHIFT, mouse:272, resizewindow

    #Brightness and volume keys
        bindle=,XF86MonBrightnessUp,exec,light -A 5
        bindle=,XF86MonBrightnessDown,exec,light -U 5
        bindle=,XF86AudioRaiseVolume,exec,pactl set-sink-volume @DEFAULT_SINK@ +5%  
        bindle=,XF86AudioLowerVolume,exec,pactl set-sink-volume @DEFAULT_SINK@ -5%  

     #screenshots
        bind=$mainMod,P,exec,mkdir -p ~/photos/screenshots; grim -t png -g "$(slurp)" ~/photos/screenshots/$(date +%Y-%m-%d_%H-%m-%s).png

     #Notifications
        bind=$mainMod SHIFT,N,exec, swaync-client -t -sw


     #swaylock
        bind=$mainMod SHIFT,M,exec, swaylock -f -i ~/photos/wallpapers/wallpaper.png


     #Laptop Lid
        bindl=,switch:on:Lid Switch, exec, swaylock -f -i ~/photos/wallpapers/wallpaper.png
        bindl=,switch:off:Lid Switch, exec, swaylock -f -i ~/photos/wallpapers/wallpaper.png

     # will switch to a submap called resize
        bind=$mainMod,R,submap,resize

     # will start a submap called "resize"
        submap=resize

     # sets repeatable binds for resizing the active window
        binde=,L,resizeactive,15 0
        binde=,H,resizeactive,-15 0
        binde=,K,resizeactive,0 -15
        binde=,J,resizeactive,0 15

     # use reset to go back to the global submap
        bind=,escape,submap,reset 

     # will reset the submap, meaning end the current one and return to the global one
        submap=reset
        '';

        ".config/wofi/style.css".text = ''
        *{
        font-family: ${font},monospace;
        }

        window {
        margin: 0px;
        border: 2px solid #${accent};
        background-color: #${background};
        border-radius: 20px;
        }

        #input {
        margin: 5px;
        border: none;
        color: #F5F5F5;
        background-color: #${background};
        border: 2px solid #${accent};
        border-radius: 10px;
        margin: 10px;
        }

        #inner-box {
        margin: 5px;
        border: none;
        background-color: #${background};
        border-radius: 20px;
        }

        #outer-box {
        margin: 5px;
        border: none;
        background-color: #${background};
        border-radius: 20px;
        }

        #scroll {
        margin: 0px;
        border: none;
        }

        #text {
        margin: 5px;
        border: none;
        color: #${accent};
        } 
        #text:selected{
        color:#F5F5F5;
        }

        #entry:selected {
        background-color: #${accent};
        }
        '';
    };
}
