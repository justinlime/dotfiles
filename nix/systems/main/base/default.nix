# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ username, pkgs, ... }:
{
    imports = [
        ./networking.nix
        ./packages.nix
        ./services.nix
    ];
    # Use the systemd-boot EFI boot loader.
    boot.loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
    };

    nix.settings.experimental-features= [ "nix-command" "flakes" ];
    nixpkgs.config.allowUnfree = true;

    #Set your time zone.
    time.timeZone = "America/Chicago";

    users = {
        defaultUserShell = pkgs.zsh;
        groups = {
            "${username}" = {};
        };
        users.justinlime = {
            isNormalUser = true;
            initialPassword = "gigachad";
            extraGroups = [ "wheel" "docker" "video" "libvirtd" "plugdev" "${username}" ];
            packages = with pkgs; [
            ];
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

