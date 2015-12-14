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

    # SSL
    enableSSL = true;
    sslServerKey = "/var/lib/acme/pastespace.org/key.pem";
    sslServerChain = "/var/lib/acme/pastespace.org/cert.pem";
    sslServerCert = "/var/lib/acme/pastespace.org/chain.pem";
  };

  users.users.http =
  {
    isNormalUser = true;
    home = "/home/http";
    extraGroups = [ "http" ];
  };
  users.groups.http = {};
}
