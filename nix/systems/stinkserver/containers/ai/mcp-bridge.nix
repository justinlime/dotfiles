{ ... }:
{
  virtualisation.oci-containers.containers = {
    mcp-bridge = {
     autoStart = true; 
     image = "justinlime/mcp-bridge:latest";
     ports = [ "9420:8000" ];
     environment = {
       MCP_BRIDGE__CONFIG__JSON = ''{"inference_server":{"base_url":"http://10.69.42.200:8282/v1","api_key":"None"},"mcp_servers":{"searxng":{"command":"npx","args":["-y","mcp-searxng"],"env":{"SEARXNG_URL":"http://10.69.42.200:8181"}}}}'';
     };
   };  
  };
}
