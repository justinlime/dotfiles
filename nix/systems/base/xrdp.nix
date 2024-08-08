{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [ firefox ];
  services = {
    displayManager.defaultSession = "xfce";
    xserver = {
      enable = true;
      desktopManager = {
        xterm.enable = true;
        xfce.enable = true;
      };
    };
    xrdp = {
     enable = true;
     openFirewall = true;
     defaultWindowManager = "${pkgs.xfce.xfce4-session}/bin/xfce4-session";
    };
  };
}
