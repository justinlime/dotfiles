{ config, lib, hush, ... }:
let cfg = config.jfg.ssh; in 
{
  options.jfg.ssh = with lib.types; {
    enable = lib.mkEnableOption "Enable";
  };
  config = lib.mkIf cfg.enable {
    services.fail2ban = {
      enable = true;
      maxretry = 3;
      bantime = "-1"; # Bans them forever, fuck off
      ignoreIP = [
        "192.168.0.0/16" 
        "172.16.0.0/12"
        "10.0.0.0/8"
        "127.0.0.0/8"
      ] ++ hush.ssh.fail2ban.ignoreIPs;
      jails = {
        sshd = {
          settings = {
            enabled = true; 
            findtime = "1d"; # fails within 1 day
            mode = "aggressive"; # includes keyfile attempts 
            port = "ssh";
            logpath = "%(sshd_log)s";
            backend = "%(sshd_backend)s";
          };
        };
      };
    };
    services.openssh = {
      enable = true;
      openFirewall = true;
      settings = {
        LogLevel = "VERBOSE";
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        PermitRootLogin = "no";
        PermitEmptyPasswords = false;
        Protocol = 2;
        AllowUsers = ["${config.cfg.system.username}"];
        AllowGroups = ["${config.cfg.system.username}"];
        MaxAuthTries = 3;
        ChallengeResponseAuthentication = false;
        AllowTcpForwarding = "yes";
        UsePAM = false;
      };
    };
};
}
