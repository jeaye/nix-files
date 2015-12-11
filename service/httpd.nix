{ config, pkgs, ... }:

{
  services.httpd =
  {
    enable = true;
    user = "http";
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

  environment.systemPackages =
    let pkgsUnstable = import
    (
      fetchTarball https://github.com/NixOS/nixpkgs-channels/archive/nixos-unstable.tar.gz
    ) {}; in
  [
    pkgsUnstable.letsencrypt
  ];

  users.users.http =
  {
    isNormalUser = true;
    home = "/home/http";
    createHome = true;
  };
}
