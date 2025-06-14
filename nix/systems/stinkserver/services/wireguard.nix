{ pkgs, ... }:
{
  boot.kernel.sysctl."net.ipv4.ip_foward" = 1;
  networking.nat.externalInterface = "enp3s0";
  networking.nat.internalInterfaces = [ "wg0" ];
  networking.wireguard.enable = true;
  networking.wireguard.interfaces = {
    wg0 = {
      ips = [ "10.69.69.2/32" ];
      privateKeyFile = "/configs/wireguard-keys/stinkhome-priv";
      # Enables NAT and masquerade the IP to appear that its coming from the enp3s0 interface
      postSetup = ''
        ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.69.69.0/24 -o enp3s0 -j MASQUERADE
      '';
      # This undoes the above command
      postShutdown = ''
        ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.69.69.0/24 -o enp3s0 -j MASQUERADE
      '';
      peers = [
        { # Oracle
          publicKey = "CL9FrOHvgHX5p6fWyY8JmXL6pMW0ninklTpdfGOuWCA=";
          presharedKeyFile = "/configs/wireguard-keys/oracle-psk";
          allowedIPs = [ "10.69.69.0/24" ];
          endpoint = "justinlime.dev:42069";
          persistentKeepalive = 25;
        }
      ];
    };
  };
}
