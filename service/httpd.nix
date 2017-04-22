{ config, pkgs, ... }:

let
  ssl_info = domain:
  ''
    <Directory /etc/user/http/${domain}/.well-known>
      AllowOverride None
      Options MultiViews Indexes SymLinksIfOwnerMatch IncludesNoExec
      Require method GET POST OPTIONS
    </Directory>
    Alias /.well-known/ /etc/user/http/${domain}/.well-known/

    SSLCertificateKeyFile /var/lib/acme/${domain}/key.pem
    SSLCertificateChainFile /var/lib/acme/${domain}/chain.pem
    SSLCertificateFile /var/lib/acme/${domain}/cert.pem
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

    extraModules = [ "proxy" "proxy_http" ];

    # TODO: Add proxy helper fn
    # TODO: Bring blog.jeaye.com into jeaye.com cert
    # TODO: Allow reading cert from other domain in helper fns
    virtualHosts =
    [
      {
        hostName = "pastespace.org";
        serverAliases =
        [
          "www.pastespace.org"
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
        '' + (defaults "pastespace.org");
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
        '' + (defaults "safepaste.org");
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
        '' + (defaults "upload.jeaye.com");
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
        '' + (defaults "jeaye.com");
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
        '' + (defaults "blog.jeaye.com");
        enableSSL = true;
      }
      {
        hostName = "jank-lang.org";
        serverAliases = [ "www.jank-lang.org" ];
        globalRedirect = "https://github.com/jeaye/jank";
        enableSSL = false;
      }
      {
        hostName = "bench.jank-lang.org";
        documentRoot = "/etc/user/http/bench.jank-lang.org";
        extraConfig =
        ''
          <Directory /etc/user/http/bench.jank-lang.org>
            Options -Indexes
          </Directory>

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
        '' + (defaults "fu-er.com");
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
        '' + (defaults "penelope-art.com");
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
        '' + (defaults "penny-art.com");
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
