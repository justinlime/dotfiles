{ pkgs, ... }:
{
  systemd = {
    timers = {
      "rsync_users" = {
        wantedBy = [ "timers.target" ];
        timerConfig = {
          Persistent = true; 
          OnCalendar = "hourly";
          Unit = "rsync_users.service";
        };
      };
      "rsync_users_full" = {
        wantedBy = [ "timers.target" ];
        timerConfig = {
          Persistent = true; 
          OnCalendar = "weekly";
          Unit = "rsync_users_full.service";
        };
      };
    };
    services = {
      "rsync_users" = {
        script = ''
          ${pkgs.rsync}/bin/rsync -rv --ignore-existing /drives/NVME0/users /storage/pool
        '';
      };
      "rsync_users_full" = { 
        script = ''
          ${pkgs.rsync}/bin/rsync -rv /drives/NVME0/users /storage/pool
        '';
      };
    };
  };
}
