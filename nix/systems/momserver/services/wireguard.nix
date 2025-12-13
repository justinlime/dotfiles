{ pkgs, ... }: {
  networking.wireguard.interfaces = {
    wg0 = {
      mtu = 1350;
      ips = [ "10.42.69.100/32" ];  
      postSetup = ''
        # Enable BBR for better TCP congestion control
        ${pkgs.sysctl}/bin/sysctl -w net.ipv4.tcp_congestion_control=bbr
      '';
      # postShutdown = ''
      # '';
      privateKeyFile = "/configs/wireguard-keys/momserver.priv";
      peers = [
        {
          name = "Oracle";
          publicKey = "CL9FrOHvgHX5p6fWyY8JmXL6pMW0ninklTpdfGOuWCA=";
          presharedKeyFile = "/configs/wireguard-keys/oracle.psk";
          endpoint = "158.101.111.126:42069";
          persistentKeepalive = 10;
          allowedIPs = [ "10.42.69.0/24" ];
        }     
      ];
    };
  };
}
