{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [ atheme ];

  services.nginx = {
    enable = true;
    streamConfig = ''
    server {
        listen 36420;  
        proxy_pass 127.0.0.1:6667;
    }
    '';
  };
  networking.firewall.allowedTCPPorts = [ 36420 6667 ];
  services.inspircd = {
    enable = true; 
    config = ''
    <admin name="justinlime"
      nick="justinlime"
      email="justinlime1999@gmail.com">
    <class name="Shutdown"
           commands="DIE RESTART REHASH LOADMODULE UNLOADMODULE RELOAD">
    <class name="ServerLink"
           commands="CONNECT SQUIT RCONNECT MKPASSWD MKSHA256">
    <class name="BanControl"
           commands="KILL GLINE KLINE ZLINE QLINE ELINE">
    <class name="OperChat"
           commands="WALLOPS GLOBOPS SETIDLE SPYLIST SPYNAMES">
    <class name="HostCloak"
           commands="SETHOST SETIDENT SETNAME CHGHOST CHGIDENT">
    <type name="NetAdmin"
          classes="OperChat BanControl HostCloak Shutdown ServerLink"
          host="*">
    <type name="GlobalOp"
          classes="OperChat BanControl HostCloak ServerLink"
          host="*">
    <type name="Helper"
          classes="HostCloak"
          host="*">
    <oper name="somedude"
          password="secretpass"
          host="justinlime@google.com"
          hash="hmac-sha256"
          type="NetAdmin">
    <execfiles motd="echo Sub to Virbox">
    <connect allow="*"
         timeout="60"
         flood="20"
         threshold="1"
         pingfreq="120"
         sendq="262144"
         recvq="8192"
         localmax="3"
         globalmax="3">
    <bind address="*"
         port="6667"
         type="clients"
         defer="0s"
         free="no">
    <badnick nick="OperServ" reason="Reserved For Services">
    <badnick nick="NickServ" reason="Reserved For Services">
    <badnick nick="MemoServ" reason="Reserved For Services">
    '';
  };
}
