{ config, pkgs, ... }:

# TODO: Install nextcloud
# TODO: Update script, like rainloop has

let
  hostAddr = "192.168.255.1";
  localAddr = "192.168.254.1";
in
{
  networking.extraHosts = "${hostAddr} nextcloud";
  containers.nextcloud =
  {
    autoStart = true;
    privateNetwork = true;
    hostAddress = hostAddr;
    localAddress = localAddr;

    config = { config, pkgs, ... }:
    {
      services.httpd =
      {
        enable = true;
        user = "http";
        adminAddr = "contact@jeaye.com";

        logPerVirtualHost = true;

        extraModules =
        [
          "rewrite" "headers" "env" "dir" "mime"
          { name = "php7"; path = "${pkgs.php}/modules/libphp7.so"; }
        ];

        hostName = "cloud.pastespace.org";
        documentRoot = "/etc/user/http/cloud.pastespace.org";
        extraConfig =
        ''
          <Directory /etc/user/http/cloud.pastespace.org>
            Options +FollowSymlinks
            AllowOverride All

            <IfModule mod_dav.c>
              Dav off
            </IfModule>

            SetEnv HOME /etc/user/http/cloud.pastespace.org
            SetEnv HTTP_HOME /etc/user/http/cloud.pastespace.org
          </Directory>

          # TODO: Share with host
          AddDefaultCharset UTF-8
          AddCharset UTF-8 .html .htm .txt

          ServerTokens Prod
          ServerSignature Off
          TraceEnable off
        '';
      };

      users.users.http =
      {
        isNormalUser = false;
        home = "/etc/user/http";
      };
    };
  };

  services.httpd =
  {
    virtualHosts =
    [
      #{
      #  hostName = "cloud.pastespace.org";
      #  globalRedirect = "https://cloud.pastespace.org/";
      #  enableSSL = false;
      #}
      {
        hostName = "cloud.pastespace.org";
        documentRoot = "/etc/user/http/cloud.pastespace.org";
        extraConfig =
        ''
          #SSLProxyEngine On
          ProxyPreserveHost Off
          ProxyPass /.well-known !
          ProxyPass / http://nextcloud/
          ProxyPassReverse / http://nextcloud/
        ''; #TODO + (defaults "cloud.pastespace.org" "cloud.pastespace.org");
        enableSSL = false;
      }
    ];
  };

  environment.etc =
  {
    "user/http/cloud.pastespace.org/.well-known/.manage-directory".text = "";
  };
}
