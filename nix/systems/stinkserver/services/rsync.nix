{ pkgs, ... }:
{
  systemd = {
    timers = {
      "rsync" = {
        wantedBy = [ "timers.target" ];
        timerConfig = {
          Persistent = true; 
          OnCalendar = "hourly";
          Unit = "rsync.service";
        };
      };
    };
    services = {
      "rsync" = {
        # If you dont want the dst dir to be named the same as the src,
        # use a trailing / after the src dir, like:
        # rsync -avh /drives/NVME0/users/ /storage/pool/new_users
        script = ''
          ${pkgs.rsync}/bin/rsync -avh /drives/NVME0/users /storage/pool --delete
        '';
      };
    };
  };
}
