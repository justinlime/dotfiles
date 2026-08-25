{ pkgs, ... }: {
  # Disable CoW on the torrent dir 
  systemd.services.disableCopyOnWrite = {
    description = "Disable CoW on data directory";
    wantedBy = [ "multi-user.target" ];
    after = [ "storage-data.mount" ];
    requires = [ "storage-data.mount" ];

    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.e2fsprogs}/bin/chattr +C /storage/downloads/torrent";
      RemainAfterExit = true;
    };
  };

  virtualisation.oci-containers.containers.qbittorrent = {
    autoStart = true;
    image = "lscr.io/linuxserver/qbittorrent:latest";
      dependsOn = [
        "gluetun"
      ];
    environment = {
      PUID = "1000";
      PGID = "100";
      TZ = "GMT+1";
      WEBUI_PORT = "8080";
      TORRENTING_PORT = "52065";
    };
    volumes = [
      "/configs/qbittorrent:/config"
      "/storage/downloads/torrent:/downloads"
    ];
    extraOptions = [
      # Webgui is accessible via Gluetun @ 8080
      "--network=container:gluetun"
    ];
  };
}
