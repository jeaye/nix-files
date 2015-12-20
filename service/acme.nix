{ config, pkgs, ... }:

{
  imports = [ ../pkg/acme.nix ];

  environment.systemPackages = let pkgsUnstable = import
  (
    fetchTarball https://github.com/NixOS/nixpkgs-channels/archive/nixos-unstable.tar.gz
  )
  { };
  in [ pkgsUnstable.simp_le ];

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
        plugins = [ "chain.pem" "key.pem" "cert.pem" ];
        postRun = "systemctl restart httpd.service";
      };
    };
  };
}
