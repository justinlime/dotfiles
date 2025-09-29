{ pkgs, inputs, ... }:
let
  pipecord = inputs.pipecord.packages.${pkgs.system}.default;
in
{
  systemd = {
    timers = {
      "rsync-weekly" = {
        wantedBy = [ "timers.target" ];
        timerConfig = {
          Persistent = true; 
          OnCalendar = "weekly";
          # OnCalendar = "*-*-* *:*:00"; #Every minute
          Unit = "rsync-weekly.service";
        };
      };
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
      "rsync-weekly" = {
        # If you dont want the dst dir to be named the same as the src,
        # use a trailing / after the src dir, like:
        # rsync -avh /drives/NVME0/users/ /storage/pool/new_users
        script = ''
          SRC="/configs"
          DEST="/tmp/configs_backup"
          TIMESTAMP=$(date +%F-%H%M%S)
          BACKUP_FILE="$DEST/container-configs-backup-stinkserver-$TIMESTAMP.tar.zst"

          mkdir -p "$DEST"

          tar \
            --exclude='**/logs/**' \
            --exclude='*.jpg' \
            --exclude='*.png' \
            --exclude='*.jpeg' \
            --exclude='*.webp' \
            --exclude='*.gif' \
            --exclude='*.mp4' \
            --exclude='*.mkv' \
            --exclude='*.mp3' \
            --exclude='*.flac' \
            --exclude='*.opus' \
            --exclude='*.ogg' \
            --exclude='**/Backups/**' \
            --exclude='jellyfin/cache/**' \
            --exclude='jellyfin/data/**' \
            --exclude='plex/**/Application Support/**' \
            -I "zstd -19 -T$(nproc)" -cpvf "$BACKUP_FILE" "$SRC" 

          ${pkgs.rsync}/bin/rsync -avh -info=progress2 "$BACKUP_FILE" rsync://10.42.69.1/backups/stinkserver_container_configs

          rm -rf "$BACKUP_FILE"
        '';
      };
      "rsync-hourly" = {
        # If you dont want the dst dir to be named the same as the src,
        # use a trailing / after the src dir, like:
        # rsync -avh /drives/NVME0/users/ /storage/pool/new_users
        script = ''
          ${pkgs.rsync}/bin/rsync -avh /drives/NVME0/users /storage/pool --delete 
          ${pkgs.rsync}/bin/rsync -avh rsync://10.42.69.1/backups /storage/backups --delete 
          ${pkgs.rsync}/bin/rsync -avh /storage/backups /storage/pool/backups --delete 
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
