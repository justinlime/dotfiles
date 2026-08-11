{
  virtualisation.oci-containers.containers = {
    opencloud = {
      autoStart = true;
      environmentFiles = [
        "/containers/opencloud/opencloud.env"
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
        "/containers/opencloud/opencloud-config:/etc/opencloud"
        "/containers/opencloud/opencloud-data:/var/lib/opencloud"
        "/storage/pool/cloud:/var/lib/opencloud/storage"
      ];
    };
  };
}
