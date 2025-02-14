{ config, pkgs, username, lib, ... }:
let cfg = config.homeMods.mpd; in 
{
  options.homeMods.mpd = with lib.types; {
    enable = lib.mkEnableOption "Enable"; 
    musicDirectory = lib.mkOption {
      default = "/home/${config.homeMods.home.username}/music";  
      type = str;
    };
  };

  config = lib.mkIf cfg.enable {
    services = {
      mpdris2.enable = true;
      mpd = {
        enable = true;
        musicDirectory = cfg.musicDirectory;
        network.startWhenNeeded = true;  
        extraConfig = ''
          audio_output {
            type            "pipewire"
            name            "PipeWire Sound Server"
          }
        '';
      };
    };
    # nixpkgs.overlays = [
    #   (final: prev: {
    #     ncmpcpp = prev.ncmpcpp.overrideAttrs (o: {
    #       patches = (o.patches or [ ]) ++ [
    #         (pkgs.fetchpatch {
    #           url = "https://github.com/ncmpcpp/ncmpcpp/pull/544/commits/39fa659609255b92f555dd0ef359557c8d1ef45e.patch";
    #           sha256 = "sha256-k7R1zULXY567IWmX7zUpFjib5/a+kv6KA4sF8alqBqs=";
    #         })
    #       ];
    #     });
    #   })
    # ];
    home.packages = with pkgs; [
      libnotify
      mpc-cli
      (ffmpeg-full.override { withSvtav1 = true; svt-av1=pkgs.svt-av1-psy; })
      (pkgs.writeScriptBin "songinfo" ''
        music_dir="$HOME/music"
        previewdir="$XDG_CONFIG_HOME/ncmpcpp/previews"
        mkdir -p "$previewdir"
        filename="$(mpc --format "$music_dir"/%file% current)"
        previewname="$previewdir/$(mpc --format %album% current | base64).png"

        [ -e "$previewname" ] || ffmpeg -y -i "$filename" -an -vf scale=128:128 "$previewname" > /dev/null 2>&1

        notify-send -r 27072 "Now Playing" "$(mpc --format '%title% \n%artist% - %album%' current)" -i "$previewname"
        '')
    ];
    programs = {
      ncmpcpp = {
        enable = true;
        package = pkgs.ncmpcpp.override { visualizerSupport = true; };
        bindings = [
          { key = "j"; command = "scroll_down"; }
          { key = "k"; command = "scroll_up"; }
          { key = "h"; command = "previous_column"; }
          { key = "l"; command = "next_column"; }
        ];
        settings = {
         "colors_enabled" = "yes";
         "playlist_editor_display_mode" = "columns";
         "playlist_display_mode" = "columns";
         "search_engine_display_mode" = "columns";
         "user_interface" = "alternative";
         "main_window_color" = "magenta";
         "progressbar_color" = "white";
         "current_item_prefix" = "$(cyan)$r";
         "current_item_suffix" = "$/r$(end)";
         "current_item_inactive_column_prefix" = "$(magenta)$r";
         "volume_color" = "green";
         "progressbar_elapsed_color" = "cyan";
         "execute_on_song_change" = "songinfo"; 
         "lyrics_fetchers" = "musixmatch, sing365, metrolyrics, justsomelyrics, jahlyrics, plyrics, tekstowo, zeneszoveg, internet";
        };
      };
    };
  };
}
