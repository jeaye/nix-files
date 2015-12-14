{ config, pkgs, ... }:

{
  nixpkgs.config =
  {
    packageOverrides = pkgs: rec
    {
      simp_le = pkgs.callPackage ../pkg/simp_le.nix { };
    };
  };
  imports =
  [
    ../pkg/acme.nix
  ];

  security.acme =
  {
    certs =
    {
      "pastespace.org" =
      {
        webroot = "/home/http/acme.pastespace.org";
        extraDomains =
        {
          "www.pastespace.org" = null;
          "mail.pastespace.org" = null;
        };
        email = "contact@jeaye.com";
        user = "acme";
        group = "acme";
        postRun = "systemctl reload httpd.service";
      };
    };
  };

  users.users.acme =
  {
    isSystemUser = true;
    group = "acme";
  };
}
