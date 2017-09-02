{ config, pkgs, ... }:

with import ../util/http.nix {};

{
  services.httpd =
  {
    enable = true;

    inherit util.http.user;
    inherit util.http.adminAddr;
    inherit util.http.logPerVirtualHost;
    inherit util.http.multiProcessingModule;

    extraModules =
    [
      "http2" "proxy" "proxy_http"
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
        '' + (util.http.domainDefaults "pastespace.org" "pastespace.org");
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
        '' + (util.http.domainDefaults "webmail.pastespace.org" "pastespace.org");
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
        '' + (util.http.domainDefaults "safepaste.org" "safepaste.org");
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
        '' + (util.http.domainDefaults "upload.jeaye.com" "upload.jeaye.com");
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
        '' + (util.http.domainDefaults "jeaye.com" "jeaye.com");
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
        '' + (util.http.domainDefaults "blog.jeaye.com" "blog.jeaye.com");
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
        '' + (util.http.domainDefaults "jank-lang.org" "jank-lang.org");
        enableSSL = true;
      }
      {
        hostName = "bench.jank-lang.org";
        globalRedirect = "https://bench.jank-lang.org/";
        enableSSL = false;
      }
      {
        hostName = "bench.jank-lang.org";
        documentRoot = "/etc/user/http/jank-lang.org";
        extraConfig =
        ''
          SSLProxyEngine On
          ProxyPreserveHost Off
          ProxyPass /.well-known !
          ProxyPass / http://localhost:3001/
          ProxyPassReverse / http://localhost:3001/
        '' + (util.http.domainDefaults "jank-lang.org" "jank-lang.org");
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
        documentRoot = "/etc/user/http/fu-er.com";
        extraConfig =
        ''
        '' + (util.http.domainDefaults "fu-er.com" "fu-er.com");
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
        '' + (util.http.domainDefaults "penelope-art.com" "penelope-art.com");
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
        '' + (util.http.domainDefaults "penny-art.com" "penny-art.com");
        enableSSL = true;
      }
      {
        hostName = "okletsplay.com";
        serverAliases = [ "www.okletsplay.com" ];
        globalRedirect = "https://okletsplay.com/";
      }
      {
        hostName = "okletsplay.com";
        serverAliases = [ "www.okletsplay.com" ];
        documentRoot = "/etc/user/http/okletsplay.com";
        extraConfig =
        ''
        '' + (util.http.domainDefaults "okletsplay.com" "okletsplay.com");
        enableSSL = true;
      }
    ];

    extraConfig = util.http.extraConfig;
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
    "user/http/upload.jeaye.com/.well-known/.manage-directory".text = "";
    "user/http/upload.jeaye.com/tmp/.manage-directory".text = "";
    "user/http/fu-er.com/.well-known/.manage-directory".text = "";
    "user/http/penelope-art.com/.well-known/.manage-directory".text = "";
    "user/http/penny-art.com/.well-known/.manage-directory".text = "";
    "user/http/okletsplay.com/.well-known/.manage-directory".text = "";
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
