{ pkgs, ... }: {
  networking.wg-quick.interfaces = {
    wg0 = {
      mtu = 1350;
      address = [ "10.42.69.100/32" ];  
      postUp = ''
        # Enable BBR for better TCP congestion control
        ${pkgs.sysctl}/bin/sysctl -w net.ipv4.tcp_congestion_control=bbr
        ${pkgs.sysctl}/bin/sysctl -w net.ipv4.ip_forward=1
        ${pkgs.nftables}/bin/nft list table inet wgtable >/dev/null 2>&1 || ${pkgs.nftables}/bin/nft add table inet wgtable
        ${pkgs.nftables}/bin/nft list chain inet wgtable forward >/dev/null 2>&1 || ${pkgs.nftables}/bin/nft add chain inet wgtable forward { type filter hook forward priority 0 \; }
        ${pkgs.nftables}/bin/nft list chain inet wgtable forward | ${pkgs.gnugrep}/bin/grep -q 'ct state established' || ${pkgs.nftables}/bin/nft add rule inet wgtable forward ct state established,related accept
        ${pkgs.nftables}/bin/nft list chain inet wgtable forward | ${pkgs.gnugrep}/bin/grep -q 'iifname "wg0" oifname "wg0"' || ${pkgs.nftables}/bin/nft add rule inet wgtable forward iifname "wg0" oifname "wg0" accept
        ${pkgs.nftables}/bin/nft list chain inet wgtable forward | ${pkgs.gnugrep}/bin/grep -q 'iifname "wg0" oifname "enp1s0"' || ${pkgs.nftables}/bin/nft add rule inet wgtable forward iifname "wg0" oifname "enp1s0" accept
        ${pkgs.nftables}/bin/nft list chain inet wgtable forward | ${pkgs.gnugrep}/bin/grep -q 'iifname "enp1s0" oifname "wg0"' || ${pkgs.nftables}/bin/nft add rule inet wgtable forward iifname "enp1s0" oifname "wg0" accept
        ${pkgs.nftables}/bin/nft list chain inet wgtable postrouting >/dev/null 2>&1 || ${pkgs.nftables}/bin/nft add chain inet wgtable postrouting { type nat hook postrouting priority 100 \; }
        ${pkgs.nftables}/bin/nft list chain inet wgtable postrouting | ${pkgs.gnugrep}/bin/grep -q 'oifname "enp1s0" masquerade' || ${pkgs.nftables}/bin/nft add rule inet wgtable postrouting oifname "enp1s0" masquerade
        ${pkgs.nftables}/bin/nft list chain inet wgtable input >/dev/null 2>&1 || ${pkgs.nftables}/bin/nft add chain inet wgtable input { type filter hook input priority 0 \; }
        ${pkgs.nftables}/bin/nft add rule inet wgtable input ct state established,related accept
        ${pkgs.nftables}/bin/nft add rule inet wgtable input iifname "wg0" accept
      '';
      dns = [ "10.42.69.1" ];
      privateKeyFile = "/configs/wireguard-keys/momserver.priv";
      peers = [
        {
          publicKey = "CL9FrOHvgHX5p6fWyY8JmXL6pMW0ninklTpdfGOuWCA=";
          presharedKeyFile = "/configs/wireguard-keys/oracle.psk";
          endpoint = "158.101.111.126:42069";
          persistentKeepalive = 10;
          allowedIPs = [ "10.42.69.0/24" "10.69.42.0/24" ];
        }     
      ];
    };
  };
}
