{ config, pkgs, ... }:

{
  services.httpd =
  {
    enable = true;
    user = "http";
    adminAddr = "contact@jeaye.com";

    logPerVirtualHost = true;

    extraModules = [ "proxy" "proxy_http" ];

    # TODO: Remove duplication
    # TODO: Add an acme mode which disables all SSL temporarily
    virtualHosts =
    [
      {
        hostName = "pastespace.org";
        serverAliases =
        [
          "www.pastespace.org"
          "safepaste.org"
          "www.safepaste.org"
        ];
        globalRedirect = "https://safepaste.org/";
        enableSSL = false;
      }
      {
        hostName = "pastespace.org";
        serverAliases = [ "www.pastespace.org" ];
        extraConfig =
        ''
          <Directory /etc/user/http/pastespace.org>
            Options -Indexes
          </Directory>

          SSLProxyEngine On
          ProxyPreserveHost Off
          ProxyPass /calendar http://localhost:5232/
          ProxyPassReverse /calendar http://localhost:5232/

          SSLCertificateKeyFile /var/lib/acme/pastespace.org/key.pem
          SSLCertificateChainFile /var/lib/acme/pastespace.org/chain.pem
          SSLCertificateFile /var/lib/acme/pastespace.org/cert.pem
          SSLProtocol All -SSLv2 -SSLv3
          SSLCipherSuite HIGH:!aNULL:!MD5:!EXP
          SSLHonorCipherOrder on
        '';
        enableSSL = true;
      }
      {
        hostName = "safepaste.org";
        documentRoot = "/etc/user/http/safepaste.org";
        extraConfig =
        ''
          <Directory /etc/user/http/safepaste.org>
            Options -Indexes
          </Directory>

          SSLProxyEngine On
          ProxyPreserveHost Off
          ProxyPass / http://localhost:3000/
          ProxyPassReverse / http://localhost:3000/

          SSLCertificateKeyFile /var/lib/acme/safepaste.org/key.pem
          SSLCertificateChainFile /var/lib/acme/safepaste.org/chain.pem
          SSLCertificateFile /var/lib/acme/safepaste.org/cert.pem
          SSLProtocol All -SSLv2 -SSLv3
          SSLCipherSuite HIGH:!aNULL:!MD5:!EXP
          SSLHonorCipherOrder on
        '';
        enableSSL = true;
      }
      {
        hostName = "jank-lang.org";
        serverAliases = [ "www.jank-lang.org" ];
        globalRedirect = "https://github.com/jeaye/jank";
        enableSSL = false;
      }
      {
        hostName = "upload.jeaye.com";
        globalRedirect = "https://upload.jeaye.com/";
      }
      {
        hostName = "upload.jeaye.com";
        documentRoot = "/etc/user/http/upload.jeaye.com";
        extraConfig =
        ''
          <Directory /etc/user/http/upload.jeaye.com>
            Options -Indexes
          </Directory>

          SSLCertificateKeyFile /var/lib/acme/upload.jeaye.com/key.pem
          SSLCertificateChainFile /var/lib/acme/upload.jeaye.com/chain.pem
          SSLCertificateFile /var/lib/acme/upload.jeaye.com/cert.pem
          SSLProtocol All -SSLv2 -SSLv3
          SSLCipherSuite HIGH:!aNULL:!MD5:!EXP
          SSLHonorCipherOrder on
        '';
        enableSSL = true;
      }
      {
        hostName = "jeaye.com";
        serverAliases = [ "www.jeaye.com" ];
        globalRedirect = "https://jeaye.com/";
      }
      {
        hostName = "jeaye.com";
        serverAliases = [ "www.jeaye.com" ];
        documentRoot = "/etc/user/http/jeaye.com";
        extraConfig =
        ''
          <Directory /etc/user/http/jeaye.com>
            Options -Indexes
          </Directory>

          SSLProxyEngine On
          ProxyPreserveHost Off
          ProxyPass / https://jeaye.github.io/jeaye.com/
          ProxyPassReverse / https://jeaye.github.io/jeaye.com/
          ProxyPassReverse / http://jeaye.github.io/jeaye.com/

          SSLCertificateKeyFile /var/lib/acme/jeaye.com/key.pem
          SSLCertificateChainFile /var/lib/acme/jeaye.com/chain.pem
          SSLCertificateFile /var/lib/acme/jeaye.com/cert.pem
          SSLProtocol All -SSLv2 -SSLv3
          SSLCipherSuite HIGH:!aNULL:!MD5:!EXP
          SSLHonorCipherOrder on
        '';
        enableSSL = true;
      }
      {
        hostName = "blog.jeaye.com";
        globalRedirect = "https://blog.jeaye.com/";
      }
      {
        hostName = "blog.jeaye.com";
        documentRoot = "/etc/user/http/blog.jeaye.com";
        extraConfig =
        ''
          <Directory /etc/user/http/blog.jeaye.com>
            Options -Indexes
          </Directory>

          SSLProxyEngine On
          ProxyPreserveHost Off
          ProxyPass / https://jeaye.github.io/blog.jeaye.com/
          ProxyPassReverse / https://jeaye.github.io/blog.jeaye.com/
          ProxyPassReverse / http://jeaye.github.io/blog.jeaye.com/

          SSLCertificateKeyFile /var/lib/acme/blog.jeaye.com/key.pem
          SSLCertificateChainFile /var/lib/acme/blog.jeaye.com/chain.pem
          SSLCertificateFile /var/lib/acme/blog.jeaye.com/cert.pem
          SSLProtocol All -SSLv2 -SSLv3
          SSLCipherSuite HIGH:!aNULL:!MD5:!EXP
          SSLHonorCipherOrder on
        '';
        enableSSL = true;
      }
      {
        hostName = "bench.jank-lang.org";
        documentRoot = "/etc/user/http/jank-lang.org";
        extraConfig =
        ''
          <Directory /etc/user/http/jank-lang.org>
            Options -Indexes
          </Directory>

          #SSLProxyEngine On
          ProxyPreserveHost Off
          ProxyPass / http://localhost:3001/
          ProxyPassReverse / http://localhost:3001/

          #SSLCertificateKeyFile /var/lib/acme/jank-lang.org/key.pem
          #SSLCertificateChainFile /var/lib/acme/jank-lang.org/chain.pem
          #SSLCertificateFile /var/lib/acme/jank-lang.org/cert.pem
          #SSLProtocol All -SSLv2 -SSLv3
          #SSLCipherSuite HIGH:!aNULL:!MD5:!EXP
          #SSLHonorCipherOrder on
        '';
        #enableSSL = true;
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
        documentRoot = "/etc/user/http/fu-er.com";
        extraConfig =
        ''
          <Directory /etc/user/http/fu-er.com>
            Options -Indexes
          </Directory>

          SSLCertificateKeyFile /var/lib/acme/fu-er.com/key.pem
          SSLCertificateChainFile /var/lib/acme/fu-er.com/chain.pem
          SSLCertificateFile /var/lib/acme/fu-er.com/cert.pem
          SSLProtocol All -SSLv2 -SSLv3
          SSLCipherSuite HIGH:!aNULL:!MD5:!EXP
          SSLHonorCipherOrder on
        '';
        enableSSL = true;
      }
      {
        hostName = "penelope-art.com";
        serverAliases = [ "www.penelope-art.com" ];
        globalRedirect = "https://penelope-art.com/";
        enableSSL = false;
      }
      {
        hostName = "penelope-art.com";
        serverAliases = [ "www.penelope-art.com" ];
        #globalRedirect = "https://penny.artstation.com/";
        documentRoot = "/etc/user/http/penelope-art.com";
        extraConfig =
        ''
          DirectoryIndex resume.pdf
          <Directory /etc/user/http/penelope-art.com>
            Options -Indexes
          </Directory>

          SSLCertificateKeyFile /var/lib/acme/penelope-art.com/key.pem
          SSLCertificateChainFile /var/lib/acme/penelope-art.com/chain.pem
          SSLCertificateFile /var/lib/acme/penelope-art.com/cert.pem
          SSLProtocol All -SSLv2 -SSLv3
          SSLCipherSuite HIGH:!aNULL:!MD5:!EXP
          SSLHonorCipherOrder on
        '';
        enableSSL = true;
      }
      {
        hostName = "penny-art.com";
        serverAliases = [ "www.penny-art.com" ];
        globalRedirect = "https://penny-art.com/";
        enableSSL = false;
      }
      {
        hostName = "penny-art.com";
        serverAliases = [ "www.penny-art.com" ];
        documentRoot = "/etc/user/http/penny-art.com";
        globalRedirect = "https://penny.artstation.com/";
        extraConfig =
        ''
          <Directory /etc/user/http/penny-art.com>
            Options -Indexes
          </Directory>

          SSLCertificateKeyFile /var/lib/acme/penny-art.com/key.pem
          SSLCertificateChainFile /var/lib/acme/penny-art.com/chain.pem
          SSLCertificateFile /var/lib/acme/penny-art.com/cert.pem
          SSLProtocol All -SSLv2 -SSLv3
          SSLCipherSuite HIGH:!aNULL:!MD5:!EXP
          SSLHonorCipherOrder on
        '';
        enableSSL = true;
      }
    ];

    extraConfig =
    ''
      AddDefaultCharset UTF-8
      AddCharset UTF-8 .html .htm .txt

      ServerTokens Prod
      ServerSignature Off
      TraceEnable off
    '';
  };

  users.users.http =
  {
    isNormalUser = true;
    home = "/etc/user/http";
  };

  environment.etc =
  {
    "user/http/pastespace.org/.manage-directory".text = "";
    "user/http/safepaste.org/.manage-directory".text = "";
    "user/http/jeaye.com/.manage-directory".text = "";
    "user/http/blog.jeaye.com/.manage-directory".text = "";
    "user/http/upload.jeaye.com/.manage-directory".text = "";
    "user/http/upload.jeaye.com/tmp/.manage-directory".text = "";
    "user/http/fu-er.com/.manage-directory".text = "";
    "user/http/penelope-art.com/.manage-directory".text = "";
    "user/http/penny-art.com/.manage-directory".text = "";
  };

  networking.firewall =
  {
    allowedTCPPorts =
    [
      80 # http
      443 # https
    ];
  };
}
