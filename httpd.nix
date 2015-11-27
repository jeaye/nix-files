{ config, pkgs, ... }:

{
  services.httpd = {
    enable = true;
    adminAddr = "contact@jeaye.com";
    hostName = "localhost";
    documentRoot = "/home/http/jeaye.com";

    # Logging
    logPerVirtualHost = true;

    virtualHosts = [
      {
        hostName = "v2.jeaye.com";
        documentRoot = "/home/http/jeaye.com";
      }
    ];
  };
}
