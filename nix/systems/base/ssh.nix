{ username, ... }:
{
  # Enable SSH on the machine, and open the necessary ports
  networking.firewall = {
    allowedTCPPorts = [
      22
    ];
  }
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
      PermitEmptyPasswords = false;
      Protocol = 2;
      AllowUsers = ["${username}"];
      AllowGroups = ["${username}"];
      MaxAuthTries = 3;
      ChallengeResponseAuthentication = false;
      AllowTcpForwarding = "yes";
      UsePAM = "no";
    };
  };
  users.users.${username}.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHGOXdvzorpzDQbDSNh/LJb8jXeNoQKpEPWYCJjO4vLQ" 
  ];
}
