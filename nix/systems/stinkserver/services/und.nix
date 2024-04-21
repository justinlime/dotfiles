{ username, ... }:
{
  networking.firewall = {
    allowedTCPPorts = [ 26656 ];
    allowedUDPPorts = [ 26656 ];
  };
  systemd.services.und = {
    description="Unification Mainchain Node";
    serviceConfig = {
      User=username;
      Group=username;
      WorkingDirectory="/drives/EXTERNAL1";
      EnvironmentFile="/drives/EXTERNAL1/und_archive/cosmovisor/UND_COSMOVISOR_ENV";
      Restart="always";
      RestartSec="10s";
      LimitNOFILE=4096;
      ExecStart = "/usr/local/bin/cosmovisor run start --x-crisis-skip-assert-invariants --home /drives/EXTERNAL1/und_archive";
    };
    wantedBy = [ "default.target" ];
  };
  systemd.services.und_api = {
    description="Unification Mainchain Node for API";
    serviceConfig = {
      User=username;
      Group=username;
      WorkingDirectory="/home/${username}";
      EnvironmentFile="/home/${username}/.und_mainchain_api/cosmovisor/UND_COSMOVISOR_ENV";
      Restart="always";
      RestartSec="10s";
      LimitNOFILE=4096;
      ExecStart = "/usr/local/bin/cosmovisor run start --home /home/justinlime/.und_mainchain_api";
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
  systemd.services.uniapi= {
    description="Unification API";
    serviceConfig = {
      User=username;
      Group=username;
      WorkingDirectory="/home/${username}/UnificationScriptAPI";
      Restart="always";
      RestartSec="10s";
      LimitNOFILE=4096;
      ExecStart="/home/${username}/UnificationScriptAPI/.venv/bin/python3 -m gunicorn -b 0.0.0.0:9169 uniapi.__main__:app";
    };
    wantedBy = [ "default.target" ];
  };
  services.nginx = {
    enable = true;
    virtualHosts = {
      "rest.scripts.refundvalidator.com" = {
        serverName = "rest.scripts.refundvalidator.com";
        listen = [{
          port = 90;
          addr = "0.0.0.0";
        }];
        locations."/" = {
          proxyPass = "http://localhost:9169";
          extraConfig = ''
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;    
          '';
        };
      };
      "rpc.unification.refundvalidator.com" = {
        serverName = "rpc.unification.refundvalidator.com";
        listen = [{
          port = 90;
          addr = "0.0.0.0";
        }];
        locations."/" = {
          proxyPass = "http://localhost:26657";
          extraConfig = ''
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;    
          '';
        };
      };
      "p2p.unification.refundvalidator.com" = {
        serverName = "p2p.unification.refundvalidator.com";
        listen = [{
          port = 90;
          addr = "0.0.0.0";
        }];
        locations."/" = {
          proxyPass = "http://localhost:26656";
          extraConfig = ''
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;    
          '';
        };
      };
      "158.101.111.126" = {
        serverName = "158.101.111.126";
        listen = [{
          port = 90;
          addr = "0.0.0.0";
        }];
        locations."/" = {
          proxyPass = "http://localhost:26656";
          extraConfig = ''
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;    
          '';
        };
      };
      "rest.unification.refundvalidator.com" = {
        serverName = "rest.unification.refundvalidator.com";
        listen = [{
          port = 90;
          addr = "0.0.0.0";
        }];
        locations."/" = {
          proxyPass = "http://localhost:1317";
          extraConfig = ''
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;    
          '';
        };
      };
      "grpc.unification.refundvalidator.com" = {
        serverName = "grpc.unification.refundvalidator.com";
        listen = [{
          port = 90;
          addr = "0.0.0.0";
        }];
        locations."/" = {
          proxyPass = "http://localhost:9090";
          extraConfig = ''
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;    
          '';
        };
      };
    };
  };
}
