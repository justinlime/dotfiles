{ ... }:
{

  systemd.tmpfiles.rules = [
    "d /configs/mcp-bridge 0755 justinlime justinlime -" #The - disables automatic cleanup, so the file wont be removed after a period
    "d /configs/mcp-bridge/uv 0755 justinlime justinlime -" #The - disables automatic cleanup, so the file wont be removed after a period
    "d /configs/mcp-bridge/npm 0755 justinlime justinlime -" #The - disables automatic cleanup, so the file wont be removed after a period
    "d /configs/mcp-bridge/docs 0755 justinlime justinlime -" #The - disables automatic cleanup, so the file wont be removed after a period
  ];
  virtualisation.oci-containers.containers = {
    mcp-bridge = {
     autoStart = true; 
     image = "justinlime/mcp-bridge:latest";
     ports = [ "9420:8000" ];
     volumes = [
       "/configs/mcp-bridge/uv:/root/.cache/uv"
       "/configs/mcp-bridge/npm:/root/.npm"
       "/configs/mcp-bridge/docs:/docs"
     ];
     environment = {
       MCP_BRIDGE__CONFIG__JSON = ''{"inference_server":{"base_url":"http://10.69.42.200:8282/v1","api_key":"None"},"mcp_servers":{"searxng":{"command":"npx","args":["-y","mcp-searxng"],"env":{"SEARXNG_URL":"http://10.69.42.200:8181"}},"easy_mcp_rag":{"command":"uvx","args":["--from","git+https://github.com/justinlime/easy_mcp_rag.git","easy_mcp_rag","--qdrant-host","10.69.42.200","--qdrant-port","6333","--data-dir","/docs","--batch-size","8"]}}}'';
# Expanded

# {
#   "inference_server": {
#     "base_url": "http://10.69.42.200:8282/v1",
#     "api_key": "None"
#   },
#   "mcp_servers": {
#     "searxng": {
#       "command": "npx",
#       "args": ["-y", "mcp-searxng"],
#       "env": {
#         "SEARXNG_URL": "http://10.69.42.200:8181"
#       }
#     },
#     "easy_mcp_rag": {
#       "command": "uvx",
#       "args": [
#         "--from",
#         "git+https://github.com/justinlime/easy_mcp_rag.git",
#         "easy_mcp_rag"
#         "--qdrant-host"
#         "10.69.42.200"
#         "--qdrant-port"
#         "6333"
#         "--data-dir"
#         "/docs"
#       ],
#     }
#   }
# }
     };
   };  
  };
}
