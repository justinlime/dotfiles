{ ... }:

{

  virtualisation.oci-containers.containers = {

    paperless-broker = {
      autoStart = true;
      image = "docker.io/valkey/valkey:9-alpine";
      networks = [ "network" ];
      volumes = [
        "/containers/paperless/redisdata:/data"
      ];
    };

    paperless-db = {
      autoStart = true;
      image = "docker.io/library/postgres:18";
      networks = [ "network" ];
      environment = {
        POSTGRES_DB = "paperless";
        POSTGRES_USER = "paperless";
        POSTGRES_PASSWORD = "paperless";
      };
      volumes = [
        "/containers/paperless/db:/var/lib/postgresql"
      ];
    };

    paperless-webserver = {
      autoStart = true;
      image = "ghcr.io/paperless-ngx/paperless-ngx:latest";
      ports = [ "8888:8000" ];
      networks = [ "network" ];
      environmentFiles = [
        "/containers/paperless/paperless.env"
      ];
      dependsOn = [
        "paperless-db"
        "paperless-broker"
      ];
      environment = {
        PAPERLESS_REDIS = "redis://paperless-broker:6379";
        PAPERLESS_DBHOST = "paperless-db";
        PAPERLESS_DBENGINE = "postgresql";
        PAPERLESS_CONSUMER_POLLING="10";
        PAPERLESS_CONSUMER_RECURSIVE="true";
        PAPERLESS_CONSUMER_SUBDIRS_AS_TAGS="true";
      };
      volumes = [
        "/containers/paperless/data:/usr/src/paperless/data"
        "/storage/pool/documents/docs:/usr/src/paperless/media"
        "/storage/pool/documents/export:/usr/src/paperless/export"
        "/storage/pool/documents/consume:/usr/src/paperless/consume"
      ];
      podman.sdnotify = "healthy";
      extraOptions = [
       "--health-cmd=curl -f http://10.69.42.200:8888"
      ];
    };

    paperless-gpt = {
      autoStart = true;
      environmentFiles = [
        "/containers/paperless/paperless.env"
      ];
      image = "icereed/paperless-gpt:latest";
      networks = [ "network" ];
      dependsOn = [
        "paperless-webserver"
      ];
      environment = {
        PAPERLESS_BASE_URL = "http://paperless-webserver:8000";
        PAPERLESS_PUBLIC_URL = "http://stink:8888";
        MANUAL_TAG = "StinkGPT-Manual";
        AUTO_TAG = "StinkGPT-Auto";
        AUTO_OCR_TAG = "StinkGPT-AutoOCR";
        AUTO_GENERATE_TAGS="true";
        FAIL_TAG = "StinkGPT-Fail";
        LLM_PROVIDER = "openai";
        LLM_MODEL = "StinkGPT-Lab";
        OPENAI_API_KEY = "none";
        OPENAI_BASE_URL = "http://10.69.42.200:3999/v1";
        LLM_LANGUAGE = "English";
        OCR_PROVIDER = "llm";
        OCR_PROCESS_MODE="image";
        VISION_LLM_PROVIDER="openai";
        VISION_LLM_MODEL="StinkGPT-Lab";
        # CREATE_NEW_TAGS="true";
        LOG_LEVEL = "info";
      };
      volumes = [
        "/containers/paperless/paperless-gpt/prompts:/app/prompts"
        "/containers/paperless/paperless-gpt/config:/app/config"
      ];
      ports = [
        "8094:8080"
      ];
    };

  };
}
