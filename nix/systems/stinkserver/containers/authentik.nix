{ ... }:
{
  virtualisation.oci-containers.containers = {
    authentik-postgres = {
      autoStart = true;
      image = "docker.io/library/postgres:16-alpine";
      networks = [ "network" ];
      environmentFiles = [
        "/containers/authentik/authentik.env"
      ];
      volumes = [
        "/containers/authentik/postgresql:/var/lib/postgresql/data"
      ];
      extraOptions = [
        "--health-cmd=pg_isready -d authentik -U authentik"
        "--health-interval=30s"
        "--health-timeout=5s"
        "--health-retries=5"
        "--health-start-period=20s"
      ];
    };


    authentik-redis = {
      autoStart = true;
      image = "docker.io/library/redis:alpine";
      networks = [ "network" ];
      volumes = [
        "/containers/authentik/redis:/data"
      ];
      extraOptions = [
        "--health-cmd=redis-cli ping"
        "--health-interval=30s"
        "--health-timeout=3s"
        "--health-retries=5"
        "--health-start-period=20s"
      ];
    };


    authentik-server = {
      autoStart = true;
      image = "ghcr.io/goauthentik/server:2026.8";
      cmd = [ "server" ];
      networks = [ "network" ];
      environmentFiles = [
        "/containers/authentik/authentik.env"
      ];
      ports = [
        "9001:9000"
        "9444:9443"
      ];
      dependsOn = [
        "authentik-postgres"
        "authentik-redis"
      ];
      environment = {
        AUTHENTIK_REDIS__HOST = "authentik-redis";
      };
      volumes = [
        "/containers/authentik/data:/data"
        "/containers/authentik/media:/media"
      ];
    };


    authentik-worker = {
      autoStart = true;
      image = "ghcr.io/goauthentik/server:2026.8";
      cmd = [ "worker" ];
      user = "root";
      networks = [ "network" ];
      environmentFiles = [
        "/containers/authentik/authentik.env"
      ];
      dependsOn = [
        "authentik-postgres"
        "authentik-redis"
      ];
      environment = {
        AUTHENTIK_REDIS__HOST = "authentik-redis";
        AUTHENTIK_POSTGRESQL__HOST = "authentik-postgres";
      };
      volumes = [
        "/containers/authentik/media:/media"
        "/containers/authentik/certs:/certs"
        "/containers/authentik/templates:/templates"
      ];
    };

    # authentik-ldap = {
    #   autoStart = true;
    #   image = "ghcr.io/goauthentik/ldap:2026.5";
    #   networks = [ "network" ];
    #   ports = [
    #     "389:3389"   # LDAP
    #     "636:6636"   # LDAPS
    #   ];
    #   dependsOn = [
    #     "authentik-server"
    #   ];
    #   environment = {
    #     AUTHENTIK_HOST = "http://authentik-server:9000";
    #     AUTHENTIK_INSECURE = "true"; # Set to "false" if using internal HTTPS
    #     AUTHENTIK_TOKEN = "YOUR_OUTPOST_TOKEN_HERE";
    #   };
    # };
  };
}
