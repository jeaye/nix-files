{ config, pkgs, ... }:

{
  services.httpd =
  {
    enable = true;
    user = "http";
    adminAddr = "contact@jeaye.com";

    logPerVirtualHost = true;

    virtualHosts =
    [
      {
        hostName = "pastespace.org";
        documentRoot = "/home/http/pastespace.org";
        extraConfig =
        ''
        <Directory /home/http/pastespace.org>
          DirectoryIndex index.txt
          Options -Indexes
        </Directory>
        '';
      }
    ];
  };

  users.users.http =
  {
    isNormalUser = true;
    home = "/home/http";
    extraGroups = [ "http" ];
  };
  users.groups.http = {};
}
