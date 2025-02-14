{ config, ... }:
{
  services.snapraid = {
    enable = true;
    sync = {
      interval = "daily"; 
    };
    scrub = {
      interval = "weekly";
      olderThan = 10; # Number of days since data was last scrubbed before it can be scrubbed again.
      plan = 8; # Percentage to scrub
    };
    exclude = [ "/downloads/" ];
    parityFiles = [ "/drives/PARITY0/snapraid.parity" ];
    dataDisks = {
      d1 = "/drives/BTRFS0"; #20TB
      d2 = "/drives/BTRFS1"; #14TB
      d3 = "/drives/BTRFS2"; #14TB
      d4 = "/drives/BTRFS3"; #12TB
    };
    contentFiles = [
      "/home/${config.sysMods.system.username}/.snapraid.content"
      "/drives/BTRFS0/.snapraid.content"
      "/drives/BTRFS1/.snapraid.content"
      "/drives/BTRFS2/.snapraid.content"
      "/drives/BTRFS3/.snapraid.content"
    ];
    extraConfig = ''
      autosave 500
    '';
  };
}
