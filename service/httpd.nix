{ config, pkgs, ... }:

{
  services.httpd =
  {
    enable = true;
    adminAddr = "contact@jeaye.com";

    logPerVirtualHost = true;

    virtualHosts =
    [
      {
        hostName = "pastespace.org";
        documentRoot = "/home/http/pastespace.org";
        extraConfig =
        ''
        <Directory /home/http/pastespace.org>
          DirectoryIndex index.txt
          Options -Indexes
        </Directory>
        '';
      }
    ];
  };

  environment.systemPackages = with pkgs;
  [
    # TODO: Automatically manage certs
    #letsencrypt
  ];

  users.users.http =
  {
    isNormalUser = true;
    home = "/home/http";
    createHome = true;
  };
}
