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
        serverAliases = [ "www.pastespace.org" "mail.pastespace.org" ];
        globalRedirect = "https://pastespace.org/";
        enableSSL = false;
      }
      {
        hostName = "pastespace.org";
        serverAliases = [ "www.pastespace.org" "mail.pastespace.org" ];
        documentRoot = "/home/http/pastespace.org";
        extraConfig =
        ''
          <Directory /home/http/pastespace.org>
            DirectoryIndex index.txt
            Options -Indexes
          </Directory>
          SSLCertificateKeyFile /var/lib/acme/pastespace.org/key.pem
          SSLCertificateChainFile /var/lib/acme/pastespace.org/chain.pem
          SSLCertificateFile /var/lib/acme/pastespace.org/cert.pem
        '';
        enableSSL = true;
      }
      {
        hostName = "fu-er.com";
        serverAliases = [ "www.fu-er.com" ];
        globalRedirect = "https://fu-er.com/";
        enableSSL = false;
      }
      {
        hostName = "fu-er.com";
        serverAliases = [ "www.fu-er.com" ];
        documentRoot = "/home/http/fu-er.com";
        extraConfig =
        ''
          <Directory /home/http/fu-er.com>
            Options -Indexes
          </Directory>
          SSLCertificateKeyFile /var/lib/acme/fu-er.com/key.pem
          SSLCertificateChainFile /var/lib/acme/fu-er.com/chain.pem
          SSLCertificateFile /var/lib/acme/fu-er.com/cert.pem
        '';
        enableSSL = true;
      }
      #{
      #  hostName = "penelope-art.com";
      #  serverAliases = [ "www.penelope-art.com" ];
      #  globalRedirect = "https://penelope-art.com/";
      #  enableSSL = false;
      #}
      #{
      #  hostName = "penelope-art.com";
      #  serverAliases = [ "www.penelope-art.com" ];
      #  documentRoot = "/home/http/penelope-art.com";
      #  extraConfig =
      #  ''
      #    <Directory /home/http/penelope-art.com>
      #      Options -Indexes
      #    </Directory>
      #    SSLCertificateKeyFile /var/lib/acme/penelope-art.com/key.pem
      #    SSLCertificateChainFile /var/lib/acme/penelope-art.com/chain.pem
      #    SSLCertificateFile /var/lib/acme/penelope-art.com/cert.pem
      #  '';
      #  enableSSL = true;
      #}
      #{
      #  hostName = "penny-art.com";
      #  serverAliases = [ "www.penny-art.com" ];
      #  globalRedirect = "https://penny-art.com/";
      #  enableSSL = false;
      #}
      #{
      #  hostName = "penny-art.com";
      #  serverAliases = [ "www.penny-art.com" ];
      #  documentRoot = "/home/http/penny-art.com";
      #  extraConfig =
      #  ''
      #    <Directory /home/http/penny-art.com>
      #      Options -Indexes
      #    </Directory>
      #    SSLCertificateKeyFile /var/lib/acme/penny-art.com/key.pem
      #    SSLCertificateChainFile /var/lib/acme/penny-art.com/chain.pem
      #    SSLCertificateFile /var/lib/acme/penny-art.com/cert.pem
      #  '';
      #  enableSSL = true;
      #}
    ];

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
        for domain in pastespace.org fu-er.com penelope-art.com penny-art.com;
        do
          setup $domain
        done
      '';
    };
  };
}
