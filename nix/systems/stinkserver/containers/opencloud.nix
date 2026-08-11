{
  systemd.tmpfiles.rules = [
    "d /configs/opencloud 0755 justinlime justinlime -"
    "d /configs/opencloud/opencloud-config 0755 justinlime justinlime -"
    "d /configs/opencloud/opencloud-data 0755 justinlime justinlime -"
  ];

  virtualisation.oci-containers.containers = {
    opencloud = {
      autoStart = true;
      environmentFiles = [
        "/configs/opencloud/opencloud.env"
      ];
      image = "opencloudeu/opencloud-rolling:latest";
      ports = [
        "9200:9200"
      ];
      environment = {
        OC_INSECURE = "false";
        PROXY_HTTP_ADDR = "0.0.0.0:9200";
        PROXY_TLS = "false";
        OC_URL = "https://cloud.justin-li.me";
        PROXY_CSP_CONFIG_FILE_LOCATION = "/etc/opencloud/csp.yaml";
      };
      volumes = [
        "/configs/opencloud/opencloud-config:/etc/opencloud"
        "/configs/opencloud/opencloud-data:/var/lib/opencloud"
        "/storage/pool/cloud:/var/lib/opencloud/storage"
      ];
    };
  };
}
