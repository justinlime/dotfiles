{ ... }:
{
  networking.firewall.allowedTCPPorts = [ 2049 ];
  services.nfs.server = {
    enable = true;
    exports = ''
        /nfs *(rw,insecure,fsid=0,no_subtree_check,crossmnt)
        /nfs/pool *(rw,insecure,fsid=1,no_subtree_check,crossmnt)
      '';
  };
}
