{ pkgs, inputs, ... }:
let
  pipecord = inputs.pipecord.packages.${pkgs.system}.default;
in
{
  systemd = {
    timers = {
      "rsync-hourly" = {
        wantedBy = [ "timers.target" ];
        timerConfig = {
          Persistent = true; 
          OnCalendar = "hourly";
          # OnCalendar = "*-*-* *:*:00"; #Every minute
          Unit = "rsync-hourly.service";
        };
      };
      "rsync-minutely" = {
        wantedBy = [ "timers.target" ];
        timerConfig = {
          Persistent = true; 
          OnCalendar = "*-*-* *:*:00"; #Every minute
          Unit = "rsync-minutely.service";
        };
      };
    };
    services = {
      "rsync-hourly" = {
        # If you dont want the dst dir to be named the same as the src,
        # use a trailing / after the src dir, like:
        # rsync -avh /drives/NVME0/users/ /storage/pool/new_users
        script = ''
          ${pkgs.rsync}/bin/rsync -avh /drives/NVME0/users /storage/pool --delete 
        '';
      };
      "rsync-minutely" = {
        # If you dont want the dst dir to be named the same as the src,
        # use a trailing / after the src dir, like:
        # rsync -avh /drives/NVME0/users/ /storage/pool/new_users
        script = ''
          ${pkgs.rsync}/bin/rsync -avh /home/justinlime/sync/notes/ /storage/users/justin/Notes --delete 
        '';
      };
    };
  };
}
