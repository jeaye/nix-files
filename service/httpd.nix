{ config, pkgs, ... }:

let
  ssl_info = domain: cert_domain:
  ''
    <Directory /etc/user/http/${domain}/.well-known>
      AllowOverride None
      Options MultiViews Indexes SymLinksIfOwnerMatch IncludesNoExec
      Require method GET POST OPTIONS
    </Directory>
    Alias /.well-known/ /etc/user/http/${domain}/.well-known/

    SSLCertificateKeyFile /var/lib/acme/${cert_domain}/key.pem
    SSLCertificateChainFile /var/lib/acme/${cert_domain}/chain.pem
    SSLCertificateFile /var/lib/acme/${cert_domain}/cert.pem
    SSLProtocol All -SSLv2 -SSLv3
    SSLCipherSuite HIGH:!aNULL:!MD5:!EXP
    SSLHonorCipherOrder on
  '';
  ignore_directory = domain:
  ''
    <Directory /etc/user/http/${domain}>
      Options -Indexes
    </Directory>
  '';
  defaults = domain: cert_domain: (ignore_directory domain) + (ssl_info domain cert_domain);
in
{
  services.httpd =
  {
    enable = true;
    user = "http";
    adminAddr = "contact@jeaye.com";

    logPerVirtualHost = true;

    extraModules =
    [
      "proxy" "proxy_http"
      { name = "php7"; path = "${pkgs.php}/modules/libphp7.so"; }
    ];

    # TODO: Add proxy helper fn
    virtualHosts =
    [
      {
        hostName = "pastespace.org";
        serverAliases =
        [
          "www.pastespace.org"
          "mail.pastespace.org"
        ];
        globalRedirect = "https://pastespace.org/";
        enableSSL = false;
      }
      {
        hostName = "pastespace.org";
        serverAliases = [ "www.pastespace.org" ];
        documentRoot = "/etc/user/http/pastespace.org";
        extraConfig =
        ''
          # XXX: Requires manual creation using htpasswd
          <Location /calendar>
            AuthType Basic
            AuthName "Restricted Calendar"
            AuthBasicProvider file
            AuthUserFile /etc/user/http/auth-users
            Require valid-user
          </Location>

          SSLProxyEngine On
          ProxyPreserveHost Off
          ProxyPass /.well-known !
          ProxyPass /calendar http://localhost:5232/
          ProxyPassReverse /calendar http://localhost:5232/
        '' + (defaults "pastespace.org" "pastespace.org");
        enableSSL = true;
      }
      {
        hostName = "webmail.pastespace.org";
        globalRedirect = "https://webmail.pastespace.org/";
        enableSSL = false;
      }
      {
        hostName = "webmail.pastespace.org";
        documentRoot = "/etc/user/http/webmail.pastespace.org";
        extraConfig =
        ''
          <Directory /etc/user/http/webmail.pastespace.org>
            Options -Indexes
            Deny from all
          </Directory>
          <Directory /etc/user/http/webmail.pastespace.org/latest>
            DirectoryIndex index.php
            Options -Indexes +FollowSymLinks +ExecCGI
            AllowOverride All
            Order deny,allow
            Allow from all
            Require all granted
          </Directory>
          <Directory /etc/user/http/webmail.pastespace.org/latest/data>
            Options -Indexes
            Deny from all
          </Directory>
        '' + (defaults "webmail.pastespace.org" "pastespace.org");
        enableSSL = true;
      }
      {
        hostName = "safepaste.org";
        serverAliases =
        [
          "www.safepaste.org"
        ];
        globalRedirect = "https://safepaste.org/";
        enableSSL = false;
      }
      {
        hostName = "safepaste.org";
        documentRoot = "/etc/user/http/safepaste.org";
        extraConfig =
        ''
          SSLProxyEngine On
          ProxyPreserveHost Off
          ProxyPass /.well-known !
          ProxyPass / http://localhost:3000/
          ProxyPassReverse / http://localhost:3000/
        '' + (defaults "safepaste.org" "safepaste.org");
        enableSSL = true;
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
        '' + (defaults "upload.jeaye.com" "upload.jeaye.com");
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
          SSLProxyEngine On
          ProxyPreserveHost Off
          ProxyPass /.well-known !
          ProxyPass / https://jeaye.github.io/jeaye.com/
          ProxyPassReverse / https://jeaye.github.io/jeaye.com/
          ProxyPassReverse / http://jeaye.github.io/jeaye.com/
        '' + (defaults "jeaye.com" "jeaye.com");
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
          SSLProxyEngine On
          ProxyPreserveHost Off
          ProxyPass /.well-known !
          ProxyPass / https://jeaye.github.io/blog.jeaye.com/
          ProxyPassReverse / https://jeaye.github.io/blog.jeaye.com/
          ProxyPassReverse / http://jeaye.github.io/blog.jeaye.com/
        '' + (defaults "blog.jeaye.com" "blog.jeaye.com");
        enableSSL = true;
      }
      {
        hostName = "jank-lang.org";
        serverAliases = [ "www.jank-lang.org" ];
        globalRedirect = "https://jank-lang.org/";
        enableSSL = false;
      }
      {
        hostName = "jank-lang.org";
        serverAliases = [ "www.jank-lang.org" ];
        documentRoot = "/etc/user/http/jank-lang.org";
        extraConfig =
        ''
          RedirectMatch 301 "^\/(?!\.well-known).*" https://github.com/jeaye/jank
        '' + (defaults "jank-lang.org" "jank-lang.org");
        enableSSL = true;
      }
      {
        hostName = "bench.jank-lang.org";
        documentRoot = "/etc/user/http/bench.jank-lang.org";
        extraConfig =
        ''
          #SSLProxyEngine On
          ProxyPreserveHost Off
          ProxyPass /.well-known !
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
        # TODO: SSL
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
        '' + (defaults "fu-er.com" "fu-er.com");
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
        documentRoot = "/etc/user/http/penelope-art.com";
        extraConfig =
        ''
          DirectoryIndex resume.pdf
        '' + (defaults "penelope-art.com" "penelope-art.com");
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
        extraConfig =
        ''
          RedirectMatch 301 "^\/(?!\.well-known).*" https://penny.artstation.com/
        '' + (defaults "penny-art.com" "penny-art.com");
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
    "user/http/pastespace.org/.well-known/.manage-directory".text = "";
    "user/http/webmail.pastespace.org/.well-known/.manage-directory".text = "";
    "user/http/safepaste.org/.well-known/.manage-directory".text = "";
    "user/http/jeaye.com/.well-known/.manage-directory".text = "";
    "user/http/blog.jeaye.com/.well-known/.manage-directory".text = "";
    "user/http/jank-lang.org/.well-known/.manage-directory".text = "";
    "user/http/bench.jank-lang.org/.well-known/.manage-directory".text = "";
    "user/http/upload.jeaye.com/.well-known/.manage-directory".text = "";
    "user/http/upload.jeaye.com/tmp/.manage-directory".text = "";
    "user/http/fu-er.com/.well-known/.manage-directory".text = "";
    "user/http/penelope-art.com/.well-known/.manage-directory".text = "";
    "user/http/penny-art.com/.well-known/.manage-directory".text = "";
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
