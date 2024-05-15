{ ... }:
{
  services.pantalaimon = {
    enable = true; 
    settings = {
      Default = {
        LogLevel = "Debug";
        SSL = false;
        Notifications = false;
      };
      local-matrix = {
        Homeserver = "https://matrix.org";
        ListenAddress = "127.0.0.1";
        ListenPort = 8008;
      };
    };
  };
}
