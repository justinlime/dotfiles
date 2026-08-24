{ pkgs, ... }:

let
  # Gluetun can't resolve hostnames as the endpoint IP address
  # Since it would require networking access before the container starts
  # So we gotta do some bullshit with systemd to generate it before it starts
  # See issue 788
  vpnEndpoint = "us3.vpn.airdns.org";
  endpointEnv = "/containers/gluetun/endpoint.env";
in
{
  virtualisation.oci-containers.containers.gluetun = {
    autoStart = true;
    image = "qmcgaw/gluetun";

    networks = [ "network" ];

    capabilities = {
      NET_ADMIN = true;
    };

    devices = [
      "/dev/net/tun:/dev/net/tun"
    ];

    volumes = [
      "/containers/gluetun:/gluetun"
    ];

    ports = [
      # qBittorrent WebUI
      "8080:8080"
    ];

    environment = {
      VPN_TYPE = "wireguard";
      VPN_SERVICE_PROVIDER = "custom";
    };

    environmentFiles = [
      "/containers/gluetun/gluetun.env"
      endpointEnv
    ];
  };

  systemd.services.podman-gluetun.preStart = ''
    ip="$(${pkgs.dnsutils}/bin/dig +short A ${vpnEndpoint} | ${pkgs.coreutils}/bin/head -n1)"

    if [ -z "$ip" ]; then
      echo "Failed to resolve ${vpnEndpoint}"
      exit 1
    fi

    echo "Resolved ${vpnEndpoint} to $ip"
    echo "WIREGUARD_ENDPOINT_IP=$ip" > ${endpointEnv}
  '';
}
