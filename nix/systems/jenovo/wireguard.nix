{ pkgs, inputs, ... }: {
  environment.systemPackages = with pkgs;
    [
      wirelesstools
      iproute2
      gnugrep
      gawk
      findutils
      nettools
      wireguard-tools
    ];
  systemd = {
    timers = {
      "wireguard-auto" = {
        wantedBy = [ "timers.target" ];
        timerConfig = {
          Persistent = true; 
          # OnCalendar = "*-*-* *:*:00"; #Every minute
          OnCalendar = "*:*:0/5"; #Every 10 seconds
          # Needed when timer is in seconds
          AccuracySec = "1s";
          Unit = "wireguard-auto.service";
        };
      };
    };
    services = {
      "wireguard-auto" = {
        script = builtins.readFile "${inputs.self}/nix/systems/jenovo/wireguard.sh";
      };
    };
  };
}
