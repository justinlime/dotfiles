{ ... }:
{
  programs.mpv = {
    enable = true;
    bindings = {
      "Ctrl+s" = "playlist-shuffle";
    };
  }; 
}
