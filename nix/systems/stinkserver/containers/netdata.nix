{ pkgs, lib, ... }:
{
  networking.firewall.allowedTCPPorts = [ 19999 ];
  systemd.tmpfiles.rules = [
    "d /configs/netdata 0755 justinlime justinlime -" #The - disables automatic cleanup, so the file wont be removed after a period
    "d /configs/netdata/config 0755 justinlime justinlime -" #The - disables automatic cleanup, so the file wont be removed after a period
    "d /configs/netdata/lib 0755 justinlime justinlime -" #The - disables automatic cleanup, so the file wont be removed after a period
    "d /configs/netdata/cache 0755 justinlime justinlime -" #The - disables automatic cleanup, so the file wont be removed after a period
  ];
  # If the logs look correct, but the webgui is still not accessible, its probably a
  # LAN_NETWORK misconfiguration
  # Ensure paths for downloads is set correctly in qbittorrent itself 
  virtualisation.oci-containers.containers = {
    netdata = {
     autoStart = true; 
     image = "netdata/netdata";
     environment = {
     };
     volumes = [
       "/configs/netdata/config:/etc/netdata"
       "/configs/netdata/lib:/var/lib/netdata"
       "/configs/netdata/cache:/var/cache/netdata"
       "/:/host/root:ro,rslave"
       "/etc/passwd:/host/etc/passwd:ro"
       "/etc/group:/host/etc/group:ro"
       "/etc/localtime:/etc/localtime:ro"
       "/proc:/host/proc:ro"
       "/sys:/host/sys:ro"
       "/etc/os-release:/host/etc/os-release:ro"
       "/var/log:/host/var/log:ro"
       "/run/podman/podman.sock:/var/run/docker.sock:ro"
     ];
     extraOptions = [ "--network=host" "--cap-add=SYS_PTRACE" "--cap-add=SYS_ADMIN" ];
    };  
  };
}
