{
  systemd.tmpfiles.rules = [
    "d /containers/netbird-client 0755 root root -"
  ];

  virtualisation.oci-containers.containers = {
    netbird-client = {
      autoStart = true;
      image = "netbirdio/netbird:latest";
      extraOptions = [
        "--network=host"
        "--hostname=stinkserver"
        "--privileged"
        "--cap-add=NET_ADMIN"
        "--cap-add=SYS_ADMIN"
        "--cap-add=SYS_RESOURCE"
        "--cap-add=NET_RAW"
        "--device=/dev/net/tun:/dev/net/tun"
        "--health-cmd=ip link show wt0"
        "--health-interval=5s"
        "--health-retries=15"
        "--health-start-period=10s"
      ];
      environment = {
        "NB_MANAGEMENT_URL" = "https://netbird.justin-li.me";
        # Only needed at first container boot
        "NB_SETUP_KEY" = "";
      };
      volumes = [
        "/containers/netbird-client:/var/lib/netbird"
      ];
      entrypoint = "/bin/sh";
      cmd = [
        "-c"
        ''
          sysctl -w net.ipv4.tcp_congestion_control=bbr
          sysctl -w net.core.default_qdisc=cake
          /usr/local/bin/netbird-entrypoint.sh &
          until ip link show wt0 > /dev/null 2>&1; do sleep 1; done
          sleep 3
          ip link set dev wt0 mtu 1350
          tc qdisc replace dev wt0 root cake
          wait
        ''
      ];
    };
  };
}
