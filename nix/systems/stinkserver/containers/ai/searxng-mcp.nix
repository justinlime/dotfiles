{ ... }:
{
  virtualisation.oci-containers.containers = {
    searxng-mcp = {
     autoStart = true; 
     image = "isokoliuk/mcp-searxng:latest";
     ports = [ "9191:8080" ];
     environment = {
       SEARXNG_URL = "http://10.69.42.200:8181";
       MCP_HTTP_PORT = "8080";
     };
   };  
  };
}
