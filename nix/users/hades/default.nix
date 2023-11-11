{ profile, pkgs, inputs, flake_path, ... }:
{
  programs.home-manager.enable = true;
  nixpkgs.config.allowUnfree = true; # This is borked for some reason :D
  nixpkgs.config.allowUnfreePredicate = _: true; # Workaround for the above borked option

  home = {
    stateVersion = "22.11";
    username = "nix-on-droid";
    homeDirectory = "/data/data/com.termux.nix/files/home";
    shellAliases = {
      home-switch = "home-manager switch --flake path:/data/data/com.termux.nix/dotfiles#${profile}";
    };
    packages = with pkgs; [
      rsync
      inputs.maxfetch.packages.${pkgs.system}.default
      neofetch
      git
      netcat
      vim
      zip
      unzip
      tar
      htop
      coreutils-full
      curl
      wget
      speedtest-cli
      inetutils
    ];
  };
  programs.zsh.enable = true;
}
