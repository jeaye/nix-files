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
        globalRedirect = "https://pastespace.org/";
        enableSSL = false;
      }
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
        enableSSL = true;
      }
    ];

    sslServerKey = "/var/lib/acme/pastespace.org/key.pem";
    sslServerChain = "/var/lib/acme/pastespace.org/chain.pem";
    sslServerCert = "/var/lib/acme/pastespace.org/cert.pem";
  };

  users.users.http =
  {
    isNormalUser = true;
    home = "/home/http";
    extraGroups = [ "http" ];
  };
  users.groups.http = {};

  system.activationScripts =
  {
    http =
    {
      deps = [];
      text =
      ''
        mkdir -p /home/http/pastespace.org
        chown http:users /home/http/pastespace.org
      '';
    };
  };
}
