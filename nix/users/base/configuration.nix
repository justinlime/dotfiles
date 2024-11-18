{ profile, inputs, pkgs, username, flake_path, ... }:
{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  nixpkgs.config.allowUnfree = true; # This is borked for some reason :D
  nixpkgs.config.allowUnfreePredicate = _: true; # Workaround for the above borked option

  home = {
    username = username;
    homeDirectory = "/home/${username}";
    shellAliases = {
      home-switch = "home-manager switch --flake path:${flake_path}#${profile}";
      emacs = "COLORTERM=truecolor emacs -nw";
      ga = "git add";
      gs = "git status";
      gb = "git branch";
      gm = "git merge";
      gpl = "git pull";
      gplo = "git pull origin";
      gps = "git push";
      gpso = "git push origin";
      gc = "git commit";
      gcm = "git commit -m";
      gch = "git checkout";
      gchb = "git checkout -b";
      gcoe = "git config user.email";
      gcon = "git config user.name";
      ls = "exa --group-directories-first";
      cat = "bat -p";
    };

    packages = with pkgs; [
    ] ++ (import ../../universal.nix pkgs inputs);
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
