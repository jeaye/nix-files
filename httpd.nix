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
      {
        hostName = "pastespace.org";
        serverAliases = "paste.jeaye.com";
        documentRoot = "/home/http/paste.jeaye.com";
        extraConfig = ''
        <Directory /home/http/paste.jeaye.com>
          AllowOverride All
          DirectoryIndex index.html index.txt
          Require all granted
        </Directory>
        '';
      }
    ];
  };

  users.extraUsers.http = {
    isNormalUser = true;
    home = "/home/http";
  };
}
