{ ... }:
{
  virtualisation.oci-containers.containers = {
    immich-server = {
      autoStart = true;
      image = "ghcr.io/immich-app/immich-server:v3.0.3";
      ports = [ "2283:2283" ];
      networks = [ "network" ];
      dependsOn = [ "immich-redis" "immich-database" ];
      environment = {
        DB_HOSTNAME = "immich-database";
        DB_USERNAME = "immich";
        DB_PASSWORD = "admin";
        DB_DATABASE_NAME = "immich";
        REDIS_HOSTNAME = "immich-redis";
      };
      volumes = [
        "/storage/pool/media/photos:/data"
        "/storage/pool/media/photos/external-upload:/external-upload"
        "/etc/localtime:/etc/localtime:ro"
      ];
      extraOptions = [ "--device=/dev/dri/intel-A380-render:/dev/dri/renderD128" ];
    };
    immich-machine-learning = {
      autoStart = true;
      # For hardware acceleration, add one of -[armnn, cuda, rocm, openvino, rknn]
      # to the image tag. This tag already has "-cuda" applied.
      image = "ghcr.io/immich-app/immich-machine-learning:v3.0.3";
      networks = [ "network" ];
      volumes = [
        "/containers/immich/machinelearning:/cache"
      ];
      extraOptions = [ "--cpus=4" ];
    };
    immich-redis = {
      autoStart = true;
      image = "docker.io/valkey/valkey:9@sha256:4963247afc4cd33c7d3b2d2816b9f7f8eeebab148d29056c2ca4d7cbc966f2d9";
      networks = [ "network" ];
    };
    immich-database = {
      autoStart = true;
      image = "ghcr.io/immich-app/postgres:14-vectorchord0.4.3-pgvectors0.2.0@sha256:bcf63357191b76a916ae5eb93464d65c07511da41e3bf7a8416db519b40b1c23";
      environment = {
        POSTGRES_PASSWORD = "admin";
        POSTGRES_USER = "immich";
        POSTGRES_DB = "immich";
        POSTGRES_INITDB_ARGS = "--data-checksums";
        # DB_STORAGE_TYPE = "HDD"; # uncomment if the DB isn't stored on SSDs
      };
      networks = [ "network" ];
      volumes = [
        "/containers/immich/db:/var/lib/postgresql/data"
      ];
      extraOptions = [ "--shm-size=128mb" ];
    };
  };
}
