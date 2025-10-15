{ ... }:
{
#   systemd.tmpfiles.rules = [
#     "d /configs/gitea 0755 justinlime justinlime -" #The - disables automatic cleanup, so the file wont be removed after a period
#   ];
#   virtualisation.oci-containers.containers = {
#     gitea = {
#      autoStart = true; 
#      image = "gitea/gitea:1.21.11";
#      environment = {
#        USER_UID = "1000";
#        USER_GID = "100";
#      };
#      ports = [ "3000:3000" "222:22" ];
#      volumes = [
#        "/storage/pool/git:/data"
#        "/etc/localtime:/etc/localtime:ro"
#      ];
#     };  
#   };
#   services.nginx = {
#     enable = true;
#     virtualHosts = {
#       "git.justin-li.me" = {
#         serverName = "git.justin-li.me";
#         forceSSL = true;
#         enableACME = true;
#         locations."/" = {
#           recommendedProxySettings = true;
#           proxyWebsockets = true;
#           proxyPass = "http://127.0.0.1:3000";
#         };
#       };
#     };
#   };
}
