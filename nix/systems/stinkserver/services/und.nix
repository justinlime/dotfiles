{ username, ... }:
{
  # networking.firewall.allowedTCPPorts = [ 9169 ];
  systemd.services.und = {
    description="Unification Mainchain Node";
    serviceConfig = {
      User=username;
      Group=username;
      WorkingDirectory="/home/${username}";
      EnvironmentFile="/home/${username}/.und_mainchain/cosmovisor/UND_COSMOVISOR_ENV";
      Restart="always";
      RestartSec="10s";
      LimitNOFILE=4096;
      ExecStart = "/usr/local/bin/cosmovisor run start";
    };
    wantedBy = [ "default.target" ];
  };
  systemd.services.rly= {
    description="Unification Relayer";
    serviceConfig = {
      User=username;
      Group=username;
      WorkingDirectory="/home/${username}";
      Restart="always";
      RestartSec="10s";
      LimitNOFILE=4096;
      ExecStart="/usr/local/bin/rly start fund-osmo --time-threshold 2880m";
    };
    wantedBy = [ "default.target" ];
  };
  # systemd.services.uniapi= {
  #   description="Unification API";
  #   serviceConfig = {
  #     User=username;
  #     Group=username;
  #     WorkingDirectory="/home/${username}/UnificationScriptAPI";
  #     Restart="always";
  #     RestartSec="10s";
  #     LimitNOFILE=4096;
  #     ExecStart="/home/${username}/UnificationScriptAPI/.venv/bin/python3 -m gunicorn -b 0.0.0.0:9169 uniapi.__main__:app";
  #   };
  #   wantedBy = [ "default.target" ];
  # };
}
