{ config, pkgs, ... }:

{
  services.httpd = {
    enable = true;
    adminAddr = "contact@jeaye.com";

    logPerVirtualHost = true;

    virtualHosts = [
      {
        hostName = "v2.jeaye.com";
        documentRoot = "/home/http/jeaye.com";
      }
    ];
  };

  users.extraUsers.http = {
    isNormalUser = true;
    home = "/home/http";
  };
}
