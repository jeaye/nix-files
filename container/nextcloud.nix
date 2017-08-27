{ config, pkgs, ... }:

# TODO: Update script, like rainloop has

# TODO: Harden
# - Disable previews
# - Enable hsts
# - Serve provided security headers

let
  hostAddr = "192.168.255.1";
  localAddr = "192.168.254.1";
in
{
  containers.nextcloud =
  {
    autoStart = true;
    privateNetwork = true;
    hostAddress = hostAddr;
    localAddress = localAddr;

    config = { config, pkgs, ... }:
    {
      # TODO: Share with host and bring in pam limits config
      security.sudo =
      {
        enable = false;
        wheelNeedsPassword = true;
      };

      networking.firewall.enable = false;

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
          <Directory /etc/user/http/cloud.pastespace.org/latest>
            Options +FollowSymlinks
            AllowOverride All
            Allow from all

            php_admin_value open_basedir /etc/user/http/cloud.pastespace.org/latest:/dev/urandom

            <IfModule mod_dav.c>
              Dav off
            </IfModule>

            SetEnv HOME /etc/user/http/cloud.pastespace.org/latest
            SetEnv HTTP_HOME /etc/user/http/cloud.pastespace.org/latest
          </Directory>
          <Directory /etc/user/http/cloud.pastespace.org>
            Options -Indexes
            Deny from all
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
        isNormalUser = true;
        home = "/etc/user/http";
        createHome = true;
      };

      # TODO: Move to container util
      system.activationScripts =
      {
        homes =
        {
          deps = [];
          text = (builtins.foldl'
          (us: u:
          ''
            ${us}
            chown -R ${u.name}:users /etc/user/${u.name}
          '')
          ''
            chmod a+rx /etc/user
          ''
          (builtins.filter (u: u.isNormalUser)
                 (map (key: builtins.getAttr key config.users.users)
                      (builtins.attrNames config.users.users))));
        };
      };

      environment.etc =
      {
        "user/http/cloud.pastespace.org/.well-known/.manage-directory".text = "";
      };

      services.mysql =
      {
        enable = true;
        package = pkgs.mysql;
        dataDir = "/var/db/mysql";
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
          ProxyPass / http://nextcloud.containers/
          ProxyPassReverse / http://nextcloud.containers/
        ''; # TODO + (defaults "cloud.pastespace.org" "cloud.pastespace.org");
        enableSSL = false;
      }
    ];
  };

  environment.etc =
  {
    "user/http/cloud.pastespace.org/.well-known/.manage-directory".text = "";
  };
}
