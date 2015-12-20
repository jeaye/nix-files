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

    extraConfig =
    ''
      AddDefaultCharset UTF-8
      AddCharset UTF-8 .html .htm .txt
    '';
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
        setup()
        {
          mkdir -p /home/http/$1
          chown http:http /home/http/$1
        }
        for domain in pastespace.org mail.jeaye.com fu-er.com penelope-art.com penny-art.com;
        do
          setup $domain
        done
      '';
    };
  };
}
