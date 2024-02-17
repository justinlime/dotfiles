{ profile, username, pkgs, flake_path, inputs, lib, ... }:
{
  # Settings that will apply to all of my systems
  nixpkgs.config.allowUnfree = true;

  time.timeZone = "America/Chicago";

  users = {
    defaultUserShell = pkgs.zsh;
    groups = {
      "${username}" = {};
    };
    users.${username} = {
      isNormalUser = true;
      initialPassword = "gigachad";
      extraGroups = [ "wheel" "storage" "video" "plugdev" "${username}" ];
    };
  };

  networking = {
    networkmanager.enable = true;
  };
    
  environment = {
    sessionVariables = rec {
      XDG_CACHE_HOME  = "$HOME/.cache";
      XDG_CONFIG_HOME = "$HOME/.config";
      XDG_DATA_HOME   = "$HOME/.local/share";
      XDG_STATE_HOME  = "$HOME/.local/state";
      # Not officially in the specification
      XDG_BIN_HOME    = "$HOME/.local/bin";
      PATH = [ 
        "${XDG_BIN_HOME}"
      ];
    };

    systemPackages = with pkgs; [
			inputs.home-manager.packages.${pkgs.system}.home-manager
    ] ++ (import ../../universal.nix pkgs inputs);

    variables = { EDITOR = "vim"; };
    pathsToLink = [ "/share/zsh" ];
  };
  services = {
    smartd = {
      enable = true;
      autodetect = true;
    };
  };

  programs.zsh = {
    enable = true;
    syntaxHighlighting.enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    setOptions = ["PROMPT_SUBST" "appendhistory"];
    shellAliases = {
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
      all-switch = "nix-switch && home-switch";
      nix-switch = "sudo nixos-rebuild switch --flake path:${flake_path}#${profile} --impure";
      all-update = "sudo nix flake update ${flake_path}# && all-switch";
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).

  system.stateVersion = "22.11"; # Did you read the comment?
}

