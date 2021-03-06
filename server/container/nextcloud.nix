{ config, pkgs, ... }:

# TODO: Update script, like rainloop has

# TODO: Harden
# - Disable previews (requires automatic php parsing)

with import ../util/http.nix {};

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

    # Used for crypto
    allowedDevices = [ { modifier = "r"; node = "/dev/urandom"; } ];

    config = { config, pkgs, ... }:
    {
      # TODO: Share with host and bring in pam limits config
      security.sudo =
      {
        enable = false;
        wheelNeedsPassword = true;
      };

      # TODO: Share with host
      i18n =
      {
        consoleFont = "Lat2-Terminus16";
        consoleKeyMap = "us";
        defaultLocale = "en_US.UTF-8";
      };
      time.timeZone = "America/Los_Angeles";

      networking.firewall.enable = false;

      services.httpd =
      util.http.defaults // {
        enable = true;
        enablePHP = true;

        # TODO: Bring in redis module
        extraModules =
        [
          "http2" "rewrite" "headers" "env" "dir" "mime"
        ];

        hostName = "cloud.pastespace.org";
        documentRoot = "/etc/user/http/cloud.pastespace.org";
        extraConfig = util.http.defaults.extraConfig +
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

          max_input_time = 60
          max_execution_time = 60
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

      # TODO: Automatically add config for enabling redis on NextCloud
      services.redis =
      {
        enable = true;
        bind = "127.0.0.1";
        #port = 0;
        #unixSocket = "/tmp/redis.sock";
        #package = pkgs.redisPhp7;
        extraConfig =
        ''
          #unixsocketperm 755
          maxclients 500
        '';
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
          ProxyPass /latest/ http://nextcloud.containers/latest/
          ProxyPassReverse /latest/ http://nextcloud.containers/latest/
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
