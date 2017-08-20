{ config, pkgs, ... }:

containers.nextcloud =
{
  autoStart = true;
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
            <Directory /etc/user/http/cloud.pastespace.org>
              Options +FollowSymlinks
              AllowOverride All

              <IfModule mod_dav.c>
                Dav off
              </IfModule>

              SetEnv HOME /etc/user/http/cloud.pastespace.org
              SetEnv HTTP_HOME /etc/user/http/cloud.pastespace.org
            </Directory>
          '';
          #enableSSL = true;
        }
      ];

      extraConfig = # TODO: Share with host
      ''
        AddDefaultCharset UTF-8
        AddCharset UTF-8 .html .htm .txt

        ServerTokens Prod
        ServerSignature Off
        TraceEnable off
      '';
    };

    environment.etc =
    {
      "user/http/cloud.pastespace.org/.well-known/.manage-directory".text = "";
    };

    users.users.http =
    {
      isNormalUser = false;
      home = "/etc/user/http";
    };

    networking.firewall =
    {
      allowedTCPPorts =
      [
        80 # http
        443 # https
      ];
    };
  };
};
