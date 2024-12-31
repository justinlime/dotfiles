{ pkgs, username, ... }:
  let
    mount = (pkgs.writeScriptBin "usb-mount.sh" ''
      #!/bin/sh
      PATH=$PATH:/run/current-system/sw/bin
      # This script is called from our systemd unit file to mount or unmount
      # a USB drive.
      usage()
      {
          echo "Usage: $0 {add|remove} device_name (e.g. sdb1)"
          echo $1
          echo $2
          exit 1
      }

      if [[ $# -ne 2 ]]; then
          usage
      fi

      ACTION=$1
      DEVBASE=$2
      DEVICE="/dev/''${DEVBASE}"

      # See if this drive is already mounted, and if so where
      MOUNT_POINT=$(mount | grep ''${DEVICE} | awk '{ print $3 }')

      do_mount()
      {
          if [[ -n ''${MOUNT_POINT} ]]; then
              echo "Warning: ''${DEVICE} is already mounted at ''${MOUNT_POINT}"
              exit 1
          fi

          # Get info for this drive: $ID_FS_LABEL, $ID_FS_UUID, and $ID_FS_TYPE
          eval $(blkid -o udev ''${DEVICE})

          # Figure out a mount point to use
          LABEL=''${ID_FS_LABEL}
          if [[ -z "''${LABEL}" ]]; then
              LABEL=''${DEVBASE}
          elif grep -q " /media/''${LABEL} " /etc/mtab; then
              # Already in use, make a unique one
              LABEL+="-''${DEVBASE}"
          fi
          MOUNT_POINT="/media/''${LABEL}"

          echo "Mount point: ''${MOUNT_POINT}"

          mkdir -p ''${MOUNT_POINT}

          # Global mount options
          OPTS="rw,noatime"

          # File system type specific mount options
          if [[ ''${ID_FS_TYPE} == "vfat" ]]; then
              OPTS+=",users,gid=100,umask=000,shortname=mixed,utf8=1,flush"
          fi
          if [[ ''${ID_FS_TYPE} == "btrfs" ]]; then
             OPTS+=",compress-force=zstd:3,autodefrag"
          fi
          if [[ ''${ID_FS_TYPE} == "exfat" ]]; then
             OPTS+=",fmask=0000,dmask=0000"
          fi

          if ! mount -o ''${OPTS} ''${DEVICE} ''${MOUNT_POINT}; then
              echo "Error mounting ''${DEVICE} (status = $?)"
              rmdir ''${MOUNT_POINT}
              exit 1
          fi

          echo "**** Mounted ''${DEVICE} at ''${MOUNT_POINT} ****"
      }

      do_unmount()
      {
          if [[ -z ''${MOUNT_POINT} ]]; then
              echo "Warning: ''${DEVICE} is not mounted"
          else
              umount -l ''${DEVICE}
              echo "**** Unmounted ''${DEVICE}"
          fi

          # Delete all empty dirs in /media that aren't being used as mount
          # points. This is kind of overkill, but if the drive was unmounted
          # prior to removal we no longer know its mount point, and we don't
          # want to leave it orphaned...
          for f in /media/* ; do
              if [[ -n $(find "$f" -maxdepth 0 -type d -empty) ]]; then
                  if ! grep -q " $f " /etc/mtab; then
                      echo "**** Removing mount point $f"
                      rmdir "$f"
                  fi
              fi
          done
      }

      case "''${ACTION}" in
          add)
              do_mount
              ;;
          remove)
              do_unmount
              ;;
          *)
              usage
              ;;
      esac
    '');
in
{
  users.users.${username}.extraGroups = [ "kvm" "adbusers" ];
  services.udev = {
    packages = with pkgs; [
      android-udev-rules
    ];
    extraRules = ''
      KERNEL=="sd[a-z][0-9]", SUBSYSTEMS=="usb", ACTION=="add", RUN+="/bin/sh -c 'systemctl --no-block start automount-usbdrive@%k.service'"
      KERNEL=="sd[a-z][0-9]", SUBSYSTEMS=="usb", ACTION=="remove", RUN+="/bin/sh -c 'systemctl --no-block stop automount-usbdrive@%k.service'"
      KERNEL=="sd[a-z]", SUBSYSTEMS=="usb", ACTION=="add", RUN+="/bin/sh -c 'systemctl --no-block start automount-usbdrive@%k.service'"
      KERNEL=="sd[a-z]", SUBSYSTEMS=="usb", ACTION=="remove", RUN+="/bin/sh -c 'systemctl --no-block stop automount-usbdrive@%k.service'"
      '';
  };

  systemd.services = {
   "automount-usbdrive@" = {
    description="Automount USB Drives";
    serviceConfig = {
      Type="oneshot";
      RemainAfterExit = "true";
      ExecStart = "${mount}/bin/usb-mount.sh add %i";
      ExecStop = "${mount}/bin/usb-mount.sh remove %i";
    };
   };
  };
  environment.systemPackages = with pkgs; [
    mount
    btrfs-progs
    exfatprogs
    ntfs3g
    zfs
  ];
}
