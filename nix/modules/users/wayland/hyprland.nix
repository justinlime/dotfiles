{ pkgs, lib, config, jlib, ... }:
let
  inherit (jlib) hexToRGBString;
  palette = config.jfg.theme.palette;
  cfg = config.jfg.hyprland;
  #TODO: bake theme accents into theme.nix
  custom = {
    fontsize = "12";
    primary_accent = "cba6f7";
    secondary_accent = "89b4fa";
    tertiary_accent = "f5f5f5";
    background = "11111B";
    opacity = ".85";
    cursor = "Numix-Cursor";
  };
in
{
  options.jfg.hyprland = with lib.types; {
    enable = lib.mkEnableOption "Enable";
    monitors = lib.mkOption {
      default = [ ", preferred, auto, 1" ];
      type = listOf str;
    };
  };
  config = lib.mkIf cfg.enable {
    jfg.theme.enable = lib.mkForce true;
    jfg.foot.enable = lib.mkForce true;
    jfg.hypridle.enable = lib.mkForce true;
    # Extra packages my hyprland config uses
    home.packages = with pkgs; [
      libnotify
      foot 
      grim
      slurp
      swaybg
      hyprlock
      # swaylock-effects
      swaynotificationcenter
      wl-clipboard
    ];
    wayland.windowManager.hyprland = {
      enable = true;
      # package = inputs.hyprland.packages.${pkgs.system}.hyprland;
      settings = {
        "$mainMod" = "ALT";
        monitor = cfg.monitors;
          # # name,resolution,position,scale
          # # position can be negative to swtich monitor to the left or right side
          # "DP-1,3840x2160@144,0x0,1.5,bitdepth,10"
          # "DP-2,2560x1440@165,2560x0,1"
          # # I have multiple monitors that are "eDP-1", so match basec on description instead
          # "desc:Samsung Display Corp. ATNA60CL10-0,2880x1800@120,0x0,1.5,bitdepth,10"
          # "desc:BOE 0x08A8,1920x1080@60,0x0,1"
          # "desc:BOE 0x0C9E,2240x1400@60,0x0,1.333333"
          # "desc:Lenovo Group Limited 0x8BA1 0x00006003,3200x2000@165, 0x0, 1.666667"
        exec-once = [
          "waybar"
          "swaybg -i ~/photos/wallpapers/wallpaper.png"
          "hyprctl setcursor ${config.jfg.theme.cursor.name} ${builtins.toString config.jfg.theme.font.size}"
          "swaync"
        ];
        xwayland = {
          force_zero_scaling = true; 
        };
        input = {
          kb_layout = "us";
          follow_mouse = true;
          force_no_accel = 1;
          # This doesnt work :(
          # sensitivity = 0.2;
          touchpad = {
            natural_scroll = 1;
            scroll_factor = 0.2;
          };
        };
        general = {
          gaps_in = 4;
          gaps_out = 10;
          border_size = 2;
          "col.active_border" = "rgb(${hexToRGBString "," palette.magenta})";
          "col.inactive_border" = "rgba(${custom.background}00)";
          allow_tearing = true;
          layout = "dwindle";
        };
        decoration = {
          rounding = 10;
          shadow = {
            enabled = true;
            ignore_window = true;
            range = 50;
            render_power = 3;
            color = "rgba(${custom.primary_accent}00)";
            color_inactive = "rgba(${custom.background}00)";
          };
          blur = {
            enabled = true;
            size = 6;
            passes = 3;
            new_optimizations = true;
            ignore_opacity = true;
            noise = 0.0117;
            contrast = 1.2;
            xray = false;
            brightness = 1;
          };
        };
        animations = {
          enabled = true;
          bezier = [ "easeinoutsine, 0.37, 0, 0.63, 1" ];
          animation = [ 
            "windows,1,2,easeinoutsine,slide" 
            "border,1,10,default"
            "fade,1,1,default"
            "workspaces,1,2,easeinoutsine,slide"
          ];
        };
        dwindle = {
          pseudotile = true;
          preserve_split = true;
          force_split = 2;
        };
        master = {
          new_status = "slave";
        };
        gestures = {
          workspace_swipe = false;
        };
        misc = {
          vrr = 1;
          disable_hyprland_logo  = true;
          disable_splash_rendering = true;
        };
        bind = [
          # Exit to tty
          "$mainMod SHIFT, X, exit "
          # Launch
          "$mainMod, RETURN, exec, foot"
          "$mainMod, D, exec, wofi"
          ''$mainMod,P,exec,IMG=~/photos/screenshots/$(date +%Y-%m-%d_%H-%m-%s).png && mkdir -p ~/photos/screenshots && grim -g "$(slurp -d)" $IMG && wl-copy < $IMG; notify-send -i $IMG Screenshot "Screenshot saved to ''${IMG} and copied to clipboard"''
          "$mainMod ,N,exec, swaync-client -t -sw"
          "$mainMod SHIFT,M,exec, hyprlock --immediate"
          # Window Options
          "$mainMod, V, pseudo"
          "$mainMod, W, togglesplit"
          "$mainMod, F, fullscreen"
          "$mainMod, E, togglefloating "
          "$mainMod SHIFT, Q, killactive"
          # Focus Windows
          "$mainMod, H, movefocus, l"
          "$mainMod, L, movefocus, r"
          "$mainMod, K, movefocus, u"
          "$mainMod, J, movefocus, d"
          # Move Windows
          "$mainMod SHIFT,H,movewindow,l"
          "$mainMod SHIFT,L,movewindow,r"
          "$mainMod SHIFT,K,movewindow,u"
          "$mainMod SHIFT,J,movewindow,d"
          # Switch workspaces
          "$mainMod, 1, workspace, 1"
          "$mainMod, 2, workspace, 2"
          "$mainMod, 3, workspace, 3"
          "$mainMod, 4, workspace, 4"
          "$mainMod, 5, workspace, 5"
          "$mainMod, 6, workspace, 6"
          "$mainMod, 7, workspace, 7"
          "$mainMod, 8, workspace, 8"
          "$mainMod, 9, workspace, 9"
          "$mainMod, 0, workspace, 10"
          # Switch active window to workspace
          "$mainMod SHIFT, 1, movetoworkspace, 1"
          "$mainMod SHIFT, 2, movetoworkspace, 2"
          "$mainMod SHIFT, 3, movetoworkspace, 3"
          "$mainMod SHIFT, 4, movetoworkspace, 4"
          "$mainMod SHIFT, 5, movetoworkspace, 5"
          "$mainMod SHIFT, 6, movetoworkspace, 6"
          "$mainMod SHIFT, 7, movetoworkspace, 7"
          "$mainMod SHIFT, 8, movetoworkspace, 8"
          "$mainMod SHIFT, 9, movetoworkspace, 9"
          "$mainMod SHIFT, 0, movetoworkspace, 10"
          # Scroll workspace with mouse scrollwheel
          "$mainMod, mouse_down, workspace, e+1"
          "$mainMod, mouse_up, workspace, e-1"
          # OBS
          "CTRL SHIFT, S, pass,^(com\.obsproject\.Studio)$"
        ];
        bindm = [
          # Move and resize windows with mouse too
          "$mainMod, mouse:272, movewindow"
          "$mainMod SHIFT, mouse:272, resizewindow"
        ];
        bindle = [
          # Backlight Keys
          ",XF86MonBrightnessUp,exec,light -A 5"
          ",XF86MonBrightnessDown,exec,light -U 5"
          # Volume Keys
          ",XF86AudioRaiseVolume,exec,pactl set-sink-volume @DEFAULT_SINK@ +5%  "
          ",XF86AudioLowerVolume,exec,pactl set-sink-volume @DEFAULT_SINK@ -5%  "
          ",XF86AudioMute,exec,pactl set-sink-mute @DEFAULT_SINK@ toggle"
        ];
        bindl = [
          ",switch:Lid Switch, exec, hyprlock --immediate"
        ];
        windowrulev2 = [
          # "opacity ${custom.opacity} ${custom.opacity},class:^(thunar)$"
          # "opacity ${custom.opacity} ${custom.opacity},class:^(WebCord)$"
          # "opacity ${custom.opacity} ${custom.opacity},class:^(WebCord)$"
          # "opacity 0.90 0.90,class:^(Brave-browser)$"
          # "opacity 0.90 0.90,class:^(brave-browser)$"
          # "opacity 0.90 0.90,class:^(firefox)$"
          "float,class:^(pavucontrol)$"
          "float,class:^(file_progress)$"
          "float,class:^(confirm)$"
          "float,class:^(dialog)$"
          "float,class:^(download)$"
          "float,class:^(notification)$"
          "float,class:^(error)$"
          "float,class:^(confirmreset)$"
          "float,title:^(Open File)$"
          "float,title:^(branchdialog)$"
          "float,title:^(Confirm to replace files)$"
          "float,title:^(File Operation Progress)$"
          "float,title:^(mpv)$"
          # Ensure tearing for specific games
          # All games run with gamescope
          "immediate, class:^(.gamescope-wrapped)$" 
        ];
        layerrule = [
          "blur, waybar"
          "blur, wofi"
          "ignorezero, wofi"
        ];
      };
      # Submaps
      extraConfig = ''
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
        bind=$mainMod,R,submap,reset

        # will reset the submap, meaning end the current one and return to the global one
        submap=reset

        # For tearing
        env = WLR_DRM_NO_ATOMIC,1
      '';
    };
  };
}
