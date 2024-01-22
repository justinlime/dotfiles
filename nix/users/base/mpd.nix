{ pkgs, username, ... }:
{
  services = {
    mpdris2.enable = true;
    mpd = {
      enable = true;
      musicDirectory = "/home/${username}/music";
      network.startWhenNeeded = true;  
      extraConfig = ''
        audio_output {
          type            "pipewire"
          name            "PipeWire Sound Server"
        }
      '';
    };
  };
  home.packages = with pkgs; [
    libnotify
    ffmpeg
    mpc-cli
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
      ];
      settings = {
       "execute_on_song_change" = "songinfo"; 
      };
    };
  };
}
