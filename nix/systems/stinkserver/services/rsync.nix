{ pkgs, ... }:
{
  systemd.timers."rsync_users" = {
    wantedBy = [ "timers.target" ];
      timerConfig = {
        OnBootSec = "5m";
        OnUnitActiveSec = "5m";
        Unit = "rsync_users.service";
      };
  };
  
  systemd.services."rsync_users" = {
    script = ''
    ${pkgs.rsync}/bin/rsync -rv --ignore-existing /drives/NVME0/users /storage/pool
    '';
    serviceConfig = {
      OnCalendar = "*-*-* *:00:00";
      User = "root";
      Persistent = true; 
    };
  };
}
