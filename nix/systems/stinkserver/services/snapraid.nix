{ username , ... }:
{
  snapraid = {
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
      d1 = "/drives/BTRFS0";
      d2 = "/drives/BTRFS1";
      d3 = "/drives/BTRFS2";
      d4 = "/drives/BTRFS3";
    };
    contentFiles = [
      "/home/${username}/.snapraid.content"
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
