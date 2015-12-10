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
        extraConfig = ''
        <Directory /home/http/jeaye.com>
          Options -Indexes
        </Directory>
        '';
      }
      {
        hostName = "paste.jeaye.com";
        serverAliases = ["pastespace.org"];
        documentRoot = "/home/http/paste.jeaye.com";
        extraConfig = ''
        <Directory /home/http/paste.jeaye.com>
          DirectoryIndex index.html index.txt
          Options -Indexes
        </Directory>
        '';
      }
    ];
  };

  environment.systemPackages = with pkgs; [
    letsencrypt
  ];

  users.users.http = {
    isNormalUser = true;
    home = "/home/http";
    createHome = true;
  };
}
