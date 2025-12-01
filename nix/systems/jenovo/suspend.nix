{ pkgs, inputs, ... }:
{
  environment.systemPackages = with pkgs; [
    util-linux 
    brightnessctl
    systemdUkify
    kdePackages.libkscreen
    dbus
  ];
  systemd.user.services."aura-suspend" = {
    enable = true;
    after = [ "dbus.socket" ];
    requires = [ "dbus.socket" ];
    script = builtins.readFile "${inputs.self}/nix/systems/jenovo/suspend.sh";
    wantedBy = [ "graphical-session.target" ];
  };
}
