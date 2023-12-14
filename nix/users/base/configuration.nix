{ profile, inputs, pkgs, username, flake_path, ... }:
{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  nixpkgs.config.allowUnfree = true; # This is borked for some reason :D
  nixpkgs.config.allowUnfreePredicate = _: true; # Workaround for the above borked option

  home = {
    username = "${username}";
    homeDirectory = "/home/${username}";
    shellAliases = {
      home-switch = "home-manager switch --flake path:${flake_path}#${profile}";
      emacs = "COLORTERM=truecolor emacs -nw";
    };
    packages = with pkgs; [
      emacs29
      speedtest-cli
      ventoy
      websocat
      roboto
      (nerdfonts.override { fonts = [ "RobotoMono" ]; })
      pciutils
      tree
      compsize
      smartmontools
      pciutils
      unzip
      zip
      git
      htop
      btop
      wget
      curl
      vim
      rsync
    ];
  };

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  fonts.fontconfig.enable = true;
  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.11";
}
