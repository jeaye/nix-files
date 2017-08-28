{ config, pkgs, ... }:

# TODO: Update script, like rainloop has

# TODO: Harden
# - Disable previews (requires automatic php parsing)

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
        enablePHP = true;

        extraModules =
        [
          "http2" "rewrite" "headers" "env" "dir" "mime"
        ];

        hostName = "cloud.pastespace.org";
        documentRoot = "/etc/user/http/cloud.pastespace.org";
        extraConfig =
        ''
          <Directory /etc/user/http/cloud.pastespace.org/latest>
            DirectoryIndex index.php
            Options -Indexes +FollowSymLinks +ExecCGI
            AllowOverride All
            Order deny,allow
            Allow from all
            Require all granted

            Options +FollowSymlinks
            AllowOverride All

            <IfModule mod_dav.c>
              Dav off
            </IfModule>

            SetEnv HOME /etc/user/http/cloud.pastespace.org/latest
            SetEnv HTTP_HOME /etc/user/http/cloud.pastespace.org/latest
          </Directory>
          <Directory /etc/user/http/cloud.pastespace.org>
            Options -Indexes
          </Directory>

          <IfModule mod_headers.c>
            Header always set Strict-Transport-Security "max-age=15552000; includeSubDomains"
          </IfModule>

          Protocols h2 h2c http/1.1

          # TODO: Share with host
          AddDefaultCharset UTF-8
          AddCharset UTF-8 .html .htm .txt

          ServerTokens Prod
          ServerSignature Off
          TraceEnable off
        '';

        phpOptions =
        ''
          zend_extension = ${pkgs.php}/lib/php/extensions/opcache.so
          opcache.enable = 1
          opcache.enable_cli = 1
          opcache.interned_strings_buffer = 8
          opcache.max_accelerated_files = 10000
          opcache.memory_consumption = 128
          opcache.save_comments = 1
          opcache.revalidate_freq = 1

          max_input_time = 3600
          max_execution_time = 3600
        '';
      };

      users.users.http =
      {
        isNormalUser = true;
        home = "/etc/user/http";
        createHome = true;
      };

      services.cron.systemCronJobs =
      [
        "*/15 * * * * http ${pkgs.php}/bin/php -f /etc/user/http/cloud.pastespace.org/latest/cron.php"
      ];

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
          Protocols h2 h2c http/1.1

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
