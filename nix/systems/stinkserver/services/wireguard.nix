{ pkgs, ... }:
{
  # enable NAT
  networking.nat.enable = true;
  networking.nat.externalInterface = "enp3s0";
  networking.nat.internalInterfaces = [ "wg0" ];
  networking.firewall = {
    allowedUDPPorts = [ 51820 ];
  };
  networking.wireguard.enable = true;
  networking.wireguard.interfaces = {
    # "wg0" is the network interface name. You can name the interface arbitrarily.
    wg0 = {
      # Determines the IP address and subnet of the server's end of the tunnel interface.
      ips = [ "10.69.69.1/24" ];

      # The port that WireGuard listens to. Must be accessible by the client.
      listenPort = 51820;

      # This allows the wireguard server to route your traffic to the internet and hence be like a VPN
      # For this to work you have to set the dnsserver IP of your router (or dnsserver of choice) in your clients
      postSetup = ''
        ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.69.69.0/24 -o enp3s0 -j MASQUERADE
      '';

      # This undoes the above command
      postShutdown = ''
        ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.69.69.0/24 -o enp3s0 -j MASQUERADE
      '';

      # Path to the private key file.
      #
      # Note: The private key can also be included inline via the privateKey option,
      # but this makes the private key world-readable; thus, using privateKeyFile is
      # recommended.
      #
      # Generate keypair by first installing wireguard-tools
      # nix-env -iA nixos.wireguard-tools
      #
      # mkdir ./wireguard-keys
      # wg genkey > ./wireguard-keys/private
      # wg pubkey < ./wireguard-keys/private > ./wireguard-keys/public
      privateKeyFile = "/configs/wireguard-keys/server-priv";

      peers = [
        # List of allowed peers.
        # { # Feel free to give a meaningful name
        #   # Public key of the peer (not a file path).
        #   publicKey = "{client public key}";
        #   # List of IPs assigned to this peer within the tunnel subnet. Used to configure routing.
        #   allowedIPs = [ "10.100.0.2/32" ];
        # }
        # { # John Doe
        #   publicKey = "{john doe's public key}";
        #   allowedIPs = [ "10.100.0.3/32" ];
        # }

        { # Phone 
          publicKey = "K0umzDR2wAZBeBaIvosnyyWHK24uQPF5q2wpOcYZyFo=";
          presharedKeyFile = "/configs/wireguard-keys/phone-psk";
          allowedIPs = [ "10.69.69.245/32" ];
        }
      ];
    };
  };
}
