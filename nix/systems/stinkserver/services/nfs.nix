{ ... }:
{
  networking.firewall.allowedTCPPorts = [ 2049 ];
  services.nfs.server = {
    enable = true;
    exports = ''
        /nfs *(rw,insecure,fsid=0,no_subtree_check,crossmnt)
        /nfs/pool *(rw,insecure,fsid=1,no_subtree_check,crossmnt)
        /nfs/downloads *(rw,insecure,fsid=2,no_subtree_check,crossmnt)
        /nfs/users *(rw,insecure,fsid=3,no_subtree_check,crossmnt)
        /nfs/justinlime *(rw,insecure,fsid=4,no_subtree_check,crossmnt)
      '';
  };
}
