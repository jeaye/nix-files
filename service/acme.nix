{ config, pkgs, ... }:

{
  nixpkgs.config =
  {
    packageOverrides = pkgs: rec
    { simp_le = pkgs.callPackage ../pkg/simp_le.nix { }; };
  };
  imports = [ ../pkg/acme.nix ];

  security.acme =
  {
    certs =
    {
      "pastespace.org" =
      {
        webroot = "/home/http/pastespace.org";
        extraDomains =
        {
          "www.pastespace.org" = null;
          "mail.pastespace.org" = null;

          "jeaye.com" = null;
          "www.jeaye.com" = null;
          "mail.jeaye.com" = null;

          "fu-er.com" = null;
          "www.fu-er.com" = null;
          "mail.fu-er.com" = null;

          "penelope-art.com" = null;
          "www.penelope-art.com" = null;
          "mail.penelope-art.com" = null;

          "penny-art.com" = null;
          "www.penny-art.com" = null;
          "mail.penny-art.com" = null;
        };
        email = "contact@jeaye.com";
        plugins = [ "chain.pem" "key.pem" "cert.pem" "account_key.json" ];
        postRun = "systemctl restart httpd.service";
      };
    };
  };
}
